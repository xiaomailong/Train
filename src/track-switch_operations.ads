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

with Switch;
with Switch.Vectors;

package Track.Switch_Operations is

   procedure Unset (This : in out Object; S : Switch.Vectors.Cursor);
   procedure Set (
                  This : in out Object;
                  S : Switch.Vectors.Cursor;
                  Switch_Position : Switch.Position);

end Track.Switch_Operations;
