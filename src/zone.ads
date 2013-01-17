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
with Location.Oriented;

package Zone is

   type Object is tagged private;

   function Create (
                    Start : Location.Oriented.Object;
                    Length : Types.Length
                   )
                   return Object;

   -- Be carefull, Zero is not Start :
   --  Zero and Max are oriented to the outside
   --  while Start describe an orientation to apply Length,
   --  then Start is toward the inside
   function Zero (This : Object)
                 return Location.Oriented.Object;
   function Max (This : Object; Current_Track : Track.Object)
                return Location.Oriented.Object;

private

   type Object is tagged
      record
         Start : Location.Oriented.Object;
         Length : Types.Length;
      end record;

end Zone;
