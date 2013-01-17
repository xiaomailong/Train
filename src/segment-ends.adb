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

with Track;

package body Segment.Ends is

   function Zero (S : Segment.Vectors.Cursor) return Location.Oriented.Object is
   begin
      return Location.Oriented.Create (S, 0.0, Decrementing);
   end Zero;

   function Max (S : Segment.Vectors.Cursor) return Location.Oriented.Object is
   begin
      return Location.Oriented.Create (S,
                                       Track.Element(S).Max_Abscissa,
                                       Incrementing);
   end Max;

end Segment.Ends;
