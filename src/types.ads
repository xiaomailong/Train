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

package Types is
   pragma Pure;

   type Index_Type is range 1 .. Constants.Number_Max_Of_Elements;

   type Meter_Precision_Millimeter is delta Constants.Millimeter range
     -Constants.Kilometer .. Constants.Kilometer;
   for Meter_Precision_Millimeter'Small use Constants.Millimeter;

   subtype Length is Meter_Precision_Millimeter range
     0.0 .. Meter_Precision_Millimeter'Last;
   subtype Abscissa is Meter_Precision_Millimeter;

end Types;
