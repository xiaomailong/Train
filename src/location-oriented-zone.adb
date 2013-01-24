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
with Segment;

package body Location.Oriented.Zone is
   use type Location.Object'Class;

   function Create
     (Start  : Location.Oriented.Object;
      Length : Types.Length)
      return   Object
   is
   begin
      return Object'(Start => Start, Length => Length);
   end Create;

   function From_Segment (S : Segment.Vectors.Cursor) return Object is
   begin
      return Create
               (Create (S, 0.0, Segment.Decrementing).Opposite,
                Track.Element (S).Max_Abscissa);
   end From_Segment;

   function Zero (This : Object) return Location.Oriented.Object is
   begin
      return Location.Oriented.Create
               (This.Start.Non_Oriented,
                Segment.Opposite_Extremity (This.Start.Extremity));
   end Zero;

   function Max (This : Object) return Location.Oriented.Object is
   begin
      return Location.Oriented.Add (This.Start, This.Length);
   end Max;

   function Constructible (This : Object) return Boolean is
      Cursor           : Segment.Vectors.Cursor;
      Cursor_Length    : Types.Abscissa;
      Cursor_Extremity : Segment.Extremity;
      use type Types.Meter_Precision_Millimeter;
      use type Segment.Extremity;
   begin
      if not (This.Length > Constants.Millimeter)
      then
         return False;
      end if;

      Cursor           := This.Start.Reference;
      Cursor_Extremity := This.Start.Extremity;
      case Cursor_Extremity is
         when Segment.Incrementing =>
            Cursor_Length := This.Start.Abscissa + This.Length;
         when Segment.Decrementing =>
            Cursor_Length := This.Start.Abscissa - This.Length;
      end case;
      while not Location.Create (Cursor, Cursor_Length).Normal
        and then Current_Track.Is_Linked (Cursor, Cursor_Extremity)
      loop
         if Cursor_Extremity = Segment.Incrementing
         then
            Cursor_Length := Cursor_Length -
                             Track.Element (Cursor).Max_Abscissa;
         end if;
         if Cursor_Extremity = Segment.Incrementing
         then
            Cursor_Length := -Cursor_Length;
         end if;

         Current_Track.Next (Cursor, Cursor_Extremity);

         if Cursor_Extremity = Segment.Decrementing
         then
            Cursor_Length := Track.Element (Cursor).Max_Abscissa -
                             Cursor_Length;
         end if;
      end loop;

      return Location.Create (Cursor, Cursor_Length).Normal;
   end Constructible;

   function Is_Not_Null (This : Object) return Boolean is
      use type Types.Meter_Precision_Millimeter;
   begin
      return This.Length > Constants.Millimeter;
   end Is_Not_Null;

   function Comparable (Left, Right : Object) return Boolean is
   begin
      return Left.Constructible and
             Right.Constructible and
             Location.Comparable
                (Left.Start.Non_Oriented,
                 Right.Start.Non_Oriented);
   end Comparable;

   function Equal (Left, Right : Object) return Boolean is
   begin
      return Comparable (Left, Right)
            and then ((Location.Oriented.Equal (Left.Zero, Right.Zero) and
                       Location.Oriented.Equal (Left.Max, Right.Max)) or
                      (Location.Oriented.Equal (Left.Zero, Right.Max) and
                       Location.Oriented.Equal (Left.Max, Right.Zero)));
   end Equal;

   function Inter (Left, Right : Object) return Object is
      A1, B1, A2, B2, I, J : Location.Object;
      Start                : Location.Oriented.Object;
      Length               : Types.Meter_Precision_Millimeter;
   begin

      A1 := Left.Zero.Non_Oriented;
      B1 := Left.Max.Non_Oriented;
      A2 := Right.Zero.Non_Oriented;
      B2 := Right.Max.Non_Oriented;

      declare
         Swap : Location.Object;
      begin
         if not Location.LowerThan (A1.Reference, A1, B1)
         then
            Swap := A1;
            A1   := B1;
            B1   := Swap;
         end if;
         if not Location.LowerThan (A1.Reference, A2, B2)
         then
            Swap := A2;
            A2   := B2;
            B2   := Swap;
         end if;
      end;

      -- left equiv [A1;B1], right equiv [A2;B2] relative to A1.Reference
      if Location.LowerThan (A1.Reference, A1, A2)
      then
         I := A2;
      else
         I := A1;
      end if;
      if Location.LowerThan (A1.Reference, B1, B2)
      then
         J := B1;
      else
         J := B2;
      end if;

      Length := Location.Minus (A1.Reference, J, I);
      Start  :=
         Location.Oriented.Create
           (I,
            Current_Track.Relative_Extremity
               (I.Reference,
                A1.Reference,
                Segment.Incrementing));

      return Create (Start, Length);

   end Inter;

end Location.Oriented.Zone;
