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

package body Segment is

   function Create
     (Length : Types.Length)
      return Object
   is
   begin
      return Object'(
                     Max_Abscissa => Length
                    );
   end Create;

   function Max_Abscissa (This : Object) return Types.Length
   is
   begin
      return This.Max_Abscissa;
   end Max_Abscissa;

   function Opposite_Extremity (E : Extremity) return Extremity
   is
   begin
      case E is
         when Incrementing => return Decrementing;
         when Decrementing => return Incrementing;
      end case;
   end Opposite_Extremity;

end Segment;
