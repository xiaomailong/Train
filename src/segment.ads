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

package Segment is
   pragma Pure;

   type Object is tagged private;

   type Extremity is (Decrementing, Incrementing);
   function Opposite_Extremity (E : Extremity) return Extremity;

   function Create (
                    Length : Types.Length
                   )
                   return Object;

   function Max_Abscissa (This : Object) return Types.Length;

private

   type Object is tagged
      record
         Max_Abscissa : Types.Length;
      end record;
end Segment;
