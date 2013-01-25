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
with Location;
with Location.Oriented;
with Segment.Vectors;

generic
   Current_Track : access constant Track.Object;
   with package NO_Location is new Location (Current_Track);
   with package Oriented_Location is new NO_Location.Oriented (
      Current_Track);
package Zone is
   use NO_Location;
   use Oriented_Location;

   type Object is tagged private;

   function Create
     (Start  : Oriented_Location.Object;
      Length : Types.Length)
      return   Object;

   function From_Segment (S : Segment.Vectors.Cursor) return Object;

   -- Be carefull, Zero is not Start :
   --  Zero and Max are oriented to the outside
   --  while Start describe an orientation to apply Length,
   --  then Start is toward the inside
   function Zero (This : Object) return Oriented_Location.Object;
   function Max (This : Object) return Oriented_Location.Object;

   function Constructible (This : Object) return Boolean;

   function Is_Not_Null (This : Object) return Boolean;

   function Comparable (Left, Right : Object) return Boolean;

   function Equal (Left, Right : Object) return Boolean;

   function Inter (Left, Right : Object) return Object;

   function Union (Left, Right : Object) return Object;

   function Exclusion (Left, Right : Object) return Object;

   function Is_In (Left, Right : Object) return Boolean;

   function Is_In (Left : NO_Location.Object; Right : Object) return Boolean;

   function "=" (Left, Right : Object'Class) return Boolean;

   function "*" (Left, Right : Object'Class) return Object'Class;

   function "+" (Left, Right : Object'Class) return Object'Class;

   function "-" (Left, Right : Object'Class) return Object'Class;

   Non_Contiguous_Zone : exception;

private

   type Object is tagged record
      Start  : Oriented_Location.Object;
      Length : Types.Length;
   end record;

end Zone;
