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

package body Location.Topo is

   function "=" (Left, Right : Object'Class) return Boolean is
   begin
      return Equal (Current_Track.all, Left, Right);
   end "=";

   function "<" (Left, Right : Object'Class) return Boolean is
   begin
      return Lowerthan (Current_Track.all, Left, Right);
   end "<";

   function "+" (Left : Object'Class; Right : Types.Abscissa) return Object'Class is
   begin
      return Add (Current_Track.all, Left, Right);
   end "+";

   function "-" (Left : Object'Class; Right : Types.Abscissa) return Object'Class is
      use type Types.Meter_Precision_Millimeter;
   begin
      return Add (Current_Track.all, Left, -Right);
   end "-";

   function "-" (Left, Right : Object'Class) return Types.Abscissa is
   begin
      return Minus (Current_Track.all, Left, Right);
   end "-";

end Location.Topo;
