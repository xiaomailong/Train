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

package body Zone is

   function Create
     (Start : Location.Oriented.Object;
      Length : Types.Length)
      return Object
   is
   begin
      return Object'(
                     Start => Start,
                     Length => Length
                    );
   end Create;

   function Zero (This : Object)
                 return Location.Oriented.Object
   is
   begin
      return Location.Oriented.Create
        ( This.Start.Non_Oriented,
          Segment.Opposite_Extremity (This.Start.Extremity)
        );
   end Zero;

   function Max (This : Object; Current_Track : Track.Object)
                return Location.Oriented.Object
   is
   begin
      return Location.Oriented.Add
        (Current_Track, This.Start, This.Length);
   end Max;

   function Is_Not_Null (This : Object) return Boolean
   is
      use type Types.Meter_Precision_Millimeter;
   begin return This.Length > Constants.Millimeter; end Is_Not_Null;

   function Inter (Current_Track : Track.Object; Left, Right : Object)
                  return Object
   is
      A1, B1, A2, B2, I, J : Location.Object;
      Start : Location.Oriented.Object;
      Length : Types.Meter_Precision_Millimeter;
   begin

      A1 := Left.Zero.Non_Oriented;
      B1 := Left.Max (Current_Track).Non_Oriented;
      A2 := Right.Zero.Non_Oriented;
      B2 := Right.Max (Current_Track).Non_Oriented;

      declare
         Swap : Location.Object;
      begin
         if not Location.Lowerthan (Current_Track, A1.Reference, A1, B1) then
            Swap := A1;
            A1 := B1;
            B1 := Swap;
         end if;
         if not Location.Lowerthan (Current_Track, A1.Reference, A2, B2) then
            Swap := A2;
            A2 := B2;
            B2 := Swap;
         end if;
      end;

      -- left equiv [A1;B1], right equiv [A2;B2] relative to A1.Reference
      if Location.Lowerthan (Current_Track, A1.Reference, A1, A2)
      then
         I := A2;
      else
         I := A1;
      end if;
      if Location.Lowerthan (Current_Track, A1.Reference, B1, B2)
      then
         J := B1;
      else
         J := B2;
      end if;

      Length := Location.Minus (Current_Track, J, I);
      Start := Location.Oriented.Create
        (I, Current_Track.Relative_Extremity
           (I.Reference, A1.Reference, Segment.Incrementing));

      return Create (Start, Length);
   end Inter;

end Zone;
