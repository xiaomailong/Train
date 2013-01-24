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

with Types;
with Track;
with Segment.Vectors;

generic
   Current_Track : access constant Track.Object;
package Location.Oriented.Zone is

   type Object is tagged private;

   function Create
     (Start  : Location.Oriented.Object;
      Length : Types.Length)
      return   Object;

   function From_Segment (S : Segment.Vectors.Cursor) return Object;

   -- Be carefull, Zero is not Start :
   --  Zero and Max are oriented to the outside
   --  while Start describe an orientation to apply Length,
   --  then Start is toward the inside
   function Zero (This : Object) return Location.Oriented.Object;
   function Max (This : Object) return Location.Oriented.Object;

   function Constructible (This : Object) return Boolean;

   function Is_Not_Null (This : Object) return Boolean;

   function Comparable (Left, Right : Object) return Boolean;

   function Equal (Left, Right : Object) return Boolean;

   function Inter (Left, Right : Object) return Object;

private

   type Object is tagged record
      Start  : Location.Oriented.Object;
      Length : Types.Length;
   end record;

end Location.Oriented.Zone;
