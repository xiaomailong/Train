--  Copyright \copy 2013 Baptiste Fouques

--  This program  is free  software: you  can redistribute  it and/or  modify it
--  under the terms of  the GNU General Public License as  published by the Free
--  Software Foundation,  either version 3 of  the License, or (at  your option)
--  any later version.

--  This program is distributed in the hope  that it will be useful, but WITHOUT
--  ANY  WARRANTY;  without even  the  implied  warranty of  MERCHANTABILITY  or
--  FITNESS FOR  A PARTICULAR PURPOSE.  See  the GNU General Public  License for
--  more details.

--  You should have received a copy of the GNU General Public License along with
--  this program.  If not, see http://www.gnu.org/licenses/.

with Constants;
package body Location is

   function Create
     (Relative : Segment.Vectors.Cursor;
      Abscissa : Types.Abscissa)
      return     Object
   is
   begin
      return Object'
        (Reference_Segment  => Relative,
         Reference_Abscissa => Abscissa);
   end Create;

   function Reference (This : Object) return Segment.Vectors.Cursor is
   begin
      return This.Reference_Segment;
   end Reference;

   function Abscissa (This : Object) return Types.Abscissa is
   begin
      return This.Reference_Abscissa;
   end Abscissa;

   function Abscissa
     (This          : Object;
      Dynamic_Track : Track.Object;
      Relative      : in Segment.Vectors.Cursor)
      return          Types.Abscissa
   is
      use type Types.Meter_Precision_Millimeter;
      use type Segment.Vectors.Cursor;

      Delta_Segment    : Types.Length;
      Cursor           : Segment.Vectors.Cursor;
      Cursor_Extremity : Segment.Extremity;
   begin

      Delta_Segment    := 0.0;
      Cursor           := This.Reference;
      Cursor_Extremity := Segment.Incrementing;
      Incrementing_Loop : while Cursor /= Relative and
                                Dynamic_Track.Is_Linked
                                   (Cursor,
                                    Cursor_Extremity)
      loop
         Delta_Segment := Delta_Segment +
                          Segment.Vectors.Element (Cursor).Max_Abscissa;

         Dynamic_Track.Next (Cursor, Cursor_Extremity);

         -- Exit in case of loop
         exit Incrementing_Loop when Cursor = This.Reference;
      end loop Incrementing_Loop;

      if Cursor = Relative
      then
         case Cursor_Extremity is
            when Segment.Incrementing =>
               return This.Abscissa - Delta_Segment;
            when Segment.Decrementing =>
               return Segment.Vectors.Element (Cursor).Max_Abscissa -
                      (This.Abscissa - Delta_Segment);
         end case;
      end if;

      Delta_Segment    := 0.0;
      Cursor           := This.Reference;
      Cursor_Extremity := Segment.Decrementing;
      while Cursor /= Relative and
            Dynamic_Track.Is_Linked (Cursor, Cursor_Extremity)
      loop
         Dynamic_Track.Next (Cursor, Cursor_Extremity);
         Delta_Segment := Delta_Segment +
                          Segment.Vectors.Element (Cursor).Max_Abscissa;
      end loop;

      if Cursor = Relative
      then
         case Cursor_Extremity is
            when Segment.Incrementing =>
               return -(Delta_Segment -
                        Segment.Vectors.Element (Cursor).Max_Abscissa +
                        This.Abscissa);
            when Segment.Decrementing =>
               return Delta_Segment + This.Abscissa;
         end case;
      end if;

      raise No_Link_With_Segment;

   end Abscissa;

   -----------
   -- Topologic functions
   -----------

   function Normal (This : Object) return Boolean is
   begin
      return This.Reference_Abscissa in
         0.0 .. Track.Element (This.Reference_Segment).Max_Abscissa;
   end Normal;

   function Normalize (This : Object) return Object is
      Cursor           : Segment.Vectors.Cursor;
      Cursor_Extremity : Segment.Extremity;

      Result           : Object := This;
      Result_Extremity : Segment.Extremity;

      use type Types.Meter_Precision_Millimeter;
      use type Segment.Extremity;
   begin
      if This.Abscissa >= 0.0
      then
         Result_Extremity := Segment.Incrementing;
      else
         Result_Extremity := Segment.Decrementing;
      end if;
      Cursor           := Result.Reference;
      Cursor_Extremity := Result_Extremity;

      while not (Result.Abscissa in
            0.0 .. Segment.Vectors.Element (Result.Reference).Max_Abscissa)
      loop
         if Result_Extremity = Segment.Incrementing
         then
            Result.Reference_Abscissa := Result.Abscissa -
                                         Segment.Vectors.Element (Cursor).
              Max_Abscissa;
         end if;
         if Result_Extremity = Segment.Decrementing
         then
            Result.Reference_Abscissa := -Result.Abscissa;
         end if;

         Current_Track.all.Next (Cursor, Cursor_Extremity);

         if Cursor_Extremity = Segment.Decrementing
         then
            Result.Reference_Abscissa :=
              Segment.Vectors.Element (Cursor).Max_Abscissa - Result.Abscissa;
         end if;
         Result.Reference_Segment := Cursor;
         Result_Extremity         := Cursor_Extremity;
      end loop;

      return Result;
   end Normalize;

   function Comparable (Left, Right : Object) return Boolean is
      Cursor           : Segment.Vectors.Cursor;
      Cursor_Extremity : Segment.Extremity;
      use type Segment.Vectors.Cursor;
   begin
      Cursor           := Left.Reference;
      Cursor_Extremity := Segment.Incrementing;
      while Cursor /= Right.Reference and
            Current_Track.all.Is_Linked (Cursor, Cursor_Extremity)
      loop
         Current_Track.all.Next (Cursor, Cursor_Extremity);

         exit when Cursor = Left.Reference;
      end loop;
      if Cursor = Right.Reference
      then
         return True;
      end if;
      Cursor           := Left.Reference;
      Cursor_Extremity := Segment.Decrementing;
      while Cursor /= Right.Reference and
            Current_Track.all.Is_Linked (Cursor, Cursor_Extremity)
      loop
         Current_Track.all.Next (Cursor, Cursor_Extremity);
         exit when Cursor = Left.Reference;
      end loop;
      if Cursor = Right.Reference
      then
         return True;
      end if;

      return False;
   end Comparable;

   function Equal (Left, Right : Object) return Boolean is
      use type Types.Meter_Precision_Millimeter;
   begin
      if Left.Abscissa - Right.Abscissa (Current_Track.all, Left.Reference) in
            -Constants.Millimeter .. Constants.Millimeter
      then
         return True;
      else
         return False;
      end if;

   exception
      when No_Link_With_Segment =>
         return False;
   end Equal;

   function LowerThan
     (Reference   : Segment.Vectors.Cursor;
      Left, Right : Object)
      return        Boolean
   is
      Cursor           : Segment.Vectors.Cursor := Left.Reference;
      Cursor_Extremity : Segment.Extremity      := Segment.Incrementing;
      use type Types.Meter_Precision_Millimeter;
   begin
      -- Raise exception if there is a loop
      Current_Track.all.End_Of_Route (Cursor, Cursor_Extremity);

      if Left.Abscissa (Current_Track.all, Reference) <
         Right.Abscissa (Current_Track.all, Reference)
      then
         return True;
      else
         return False;
      end if;

   end LowerThan;

   function LowerThan (Left, Right : Object) return Boolean is
   begin
      return LowerThan (Left.Reference, Left, Right);
   end LowerThan;

   function Add
     (Reference : Segment.Vectors.Cursor;
      Left      : Object;
      Right     : Types.Abscissa)
      return      Object
   is
      Result : Object;
      use type Types.Meter_Precision_Millimeter;
   begin
      Result :=
        (Reference_Abscissa => Left.Abscissa (Current_Track.all, Reference) +
                               Right,
         Reference_Segment  => Reference);
      return Result.Normalize;
   end Add;

   function Add (Left : Object; Right : Types.Abscissa) return Object is
   begin
      return Add (Left.Reference, Left, Right);
   end Add;

   function Minus
     (Reference   : Segment.Vectors.Cursor;
      Left, Right : Object)
      return        Types.Abscissa
   is
      use type Types.Meter_Precision_Millimeter;
   begin
      return Left.Abscissa (Current_Track.all, Reference) -
             Right.Abscissa (Current_Track.all, Reference);
   end Minus;

   function Minus (Left, Right : Object) return Types.Abscissa is
      use type Types.Meter_Precision_Millimeter;
   begin
      return Minus (Left.Reference, Left, Right);
   end Minus;

   function "=" (Left, Right : Object'Class) return Boolean is
   begin
      return Equal (Left, Right);
   end "=";

   function "<" (Left, Right : Object'Class) return Boolean is
   begin
      return LowerThan (Left, Right);
   end "<";

   function "<=" (Left, Right : Object'Class) return Boolean is
   begin
      return Left < Right or Left = Right;
   end "<=";

   function "+"
     (Left  : Object'Class;
      Right : Types.Abscissa)
      return  Object'Class
   is
   begin
      return Add (Left, Right);
   end "+";

   function "-"
     (Left  : Object'Class;
      Right : Types.Abscissa)
      return  Object'Class
   is
      use type Types.Meter_Precision_Millimeter;
   begin
      return Add (Left, -Right);
   end "-";

   function "-" (Left, Right : Object'Class) return Types.Abscissa is
   begin
      return Minus (Left, Right);
   end "-";

   function "abs" (X : Object'Class) return Object'Class is
   begin
      return X.Normalize;
   end "abs";

end Location;
