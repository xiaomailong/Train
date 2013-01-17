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
     return Object
   is
   begin
      return Object'(
                     Reference_Segment => Relative,
                     Reference_Abscissa => Abscissa
                    );
   end Create;

   function Reference (This : Object)
                      return Segment.Vectors.Cursor
   is
   begin
      return This.Reference_Segment;
   end Reference;

   function Abscissa (This : Object)
                     return Types.Abscissa
   is
   begin
      return This.Reference_Abscissa;
   end Abscissa;

   function Abscissa (
                      This : Object;
                      Dynamic_Track : Track.Object;
                      Relative : in Segment.Vectors.Cursor
                     )
                     return Types.Abscissa
   is
      use type Types.Meter_Precision_Millimeter;
      use type Segment.Vectors.Cursor;

      Delta_Segment : Types.Length;
      Cursor : Segment.Vectors.Cursor;
      Cursor_Extremity : Segment.Extremity;
   begin

      Delta_Segment := 0.0;
      Cursor := This.Reference;
      Cursor_Extremity := Segment.Incrementing;
  Incrementing_Loop :
      while Cursor /= Relative
        and then Dynamic_Track.Is_Linked (Cursor, Cursor_Extremity)
      loop
         Delta_Segment := Delta_Segment
           + Segment.Vectors.Element (Cursor).Max_Abscissa;

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
               return Segment.Vectors.Element (Cursor).Max_Abscissa
                 - (This.Abscissa - Delta_Segment);
         end case;
      end if;

      Delta_Segment := 0.0;
      Cursor := This.Reference;
      Cursor_Extremity := Segment.Decrementing;
      while Cursor /= Relative
        and then Dynamic_Track.Is_Linked (Cursor, Cursor_Extremity)
      loop
            Dynamic_Track.Next (Cursor, Cursor_Extremity);
            Delta_Segment := Delta_Segment
              + Segment.Vectors.Element (Cursor).Max_Abscissa;
      end loop;

      if Cursor = Relative
      then
         case Cursor_Extremity is
            when Segment.Incrementing =>
               return
                 - (Delta_Segment
                      - Segment.Vectors.Element (Cursor).Max_Abscissa
                      + This.Abscissa);
            when Segment.Decrementing =>
               return Delta_Segment + This.Abscissa;
         end case;
      end if;

      raise No_Link_With_Segment;

   end Abscissa;

   -----------
   -- Topologic functions
   -----------

   function Normalize (This : Object; Current_Track : Track.Object)
                      return Object
   is
      Cursor : Segment.Vectors.Cursor;
      Cursor_Extremity : Segment.Extremity;

      Result : Object := This;
      Result_Extremity : Segment.Extremity;

      use type Types.Meter_Precision_Millimeter;
      use type Segment.Extremity;
   begin
      if This.Abscissa >= 0.0 then
         Result_Extremity := Segment.Incrementing;
      else
         Result_Extremity := Segment.Decrementing;
      end if;
      Cursor := Result.Reference;
      Cursor_Extremity := Result_Extremity;

      while not (Result.Abscissa
                   in 0.0 ..
                   Segment.Vectors.Element (Result.Reference).Max_Abscissa)
      loop
         Current_Track.Next (Cursor, Cursor_Extremity);

         if Result_Extremity = Segment.Incrementing then
            Result.Reference_Abscissa := Result.Abscissa
              - Segment.Vectors.Element (Result.Reference).Max_Abscissa;
         end if;
         if Cursor_Extremity = Segment.Decrementing then
            Result.Reference_Abscissa := Result.Abscissa
              - Segment.Vectors.Element (Cursor).Max_Abscissa;
         end if;
         Result.Reference_Segment := Cursor;
         Result_Extremity := Cursor_Extremity;
      end loop;

      return Result;
   end Normalize;

   function Equal
     (Current_Track : Track.Object;
      Left, Right : Object)
     return Boolean
   is
      use type Types.Meter_Precision_Millimeter;
   begin
      if Left.Abscissa - Right.Abscissa(Current_Track, Left.Reference)
        in -Constants.Millimeter .. Constants.Millimeter
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
     (Current_Track : Track.Object;
      Reference : Segment.Vectors.Cursor;
      Left, Right : Object)
      return Boolean
   is
      Cursor : Segment.Vectors.Cursor := Left.Reference;
      Cursor_Extremity : Segment.Extremity := Segment.Incrementing;
      use type Types.Meter_Precision_Millimeter;
   begin
      -- Raise exception if there is a loop
      Current_Track.End_Of_Route (Cursor, Cursor_Extremity);

      if Left.Abscissa (Current_Track, Reference)
        < Right.Abscissa (Current_Track, Reference)
      then
         return True;
      else
         return False;
      end if;

   end LowerThan;

   function LowerThan
     (Current_Track : Track.Object;
      Left, Right : Object)
      return Boolean
   is
   begin
      return Lowerthan (Current_Track, Left.Reference, Left, Right);
   end LowerThan;

   function Add
     (
      Current_Track : Track.Object;
      Reference : Segment.Vectors.Cursor;
      Left : Object;
      Right : Types.Abscissa
     )
     return Object
   is
      Result : Object;
      use type Types.Meter_Precision_Millimeter;
   begin
      Result := (
                 Reference_Abscissa =>
                   Left.Abscissa (Current_Track, Reference) + Right,
                 Reference_Segment => Reference
                );
      return Result.Normalize (Current_Track);
   end Add;

   function Add
     (Current_Track : Track.Object;
      Left : Object;
      Right : Types.Abscissa)
      return Object
   is
   begin
      return Add (Current_Track, Left.Reference, Left, Right);
   end Add;

   function Minus
     (Current_Track : Track.Object;
      Left, Right : Object)
      return Types.Abscissa
   is
      use type Types.Meter_Precision_Millimeter;
   begin
      return Left.Abscissa - Right.Abscissa (Current_Track, Left.Reference);
   end Minus;

end Location;
