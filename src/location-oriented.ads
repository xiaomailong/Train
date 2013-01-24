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

generic
   Current_Track : access constant Track.Object;
package Location.Oriented is

   type Object is new Location.Object with private;

   function Non_Oriented (This : Object) return Location.Object;

   function Create
     (Non_Oriented : Location.Object;
      Extremity    : Segment.Extremity := Segment.Incrementing)
      return         Object;

   function Create
     (Relative : Segment.Vectors.Cursor;
      Abscissa : Types.Abscissa)
      return     Object;
   function Create
     (Relative  : Segment.Vectors.Cursor;
      Abscissa  : Types.Abscissa;
      Extremity : Segment.Extremity := Segment.Incrementing)
      return      Object;

   function Opposite (This : Location.Oriented.Object) return Object;

   function Extremity (This : Object) return Segment.Extremity;
   function Extremity
     (This     : Object;
      Relative : in Segment.Vectors.Cursor)
      return     Segment.Extremity;

   function Normalize (This : Object) return Object;

   function Comparable (Left, Right : Object) return Boolean;

   function Same_Extremity (Left, Right : Object) return Boolean;

   function Equal (Left, Right : Object) return Boolean;

   function LowerThan
     (Reference   : Segment.Vectors.Cursor;
      Left, Right : Object)
      return        Boolean;

   function LowerThan (Left, Right : Object) return Boolean;

   function Add
     (Reference : Segment.Vectors.Cursor;
      Left      : Object;
      Right     : Types.Abscissa)
      return      Object;

   function Add (Left : Object; Right : Types.Abscissa) return Object;

   function Minus (Left, Right : Object) return Types.Abscissa;

   function Minus
     (Reference   : Segment.Vectors.Cursor;
      Left, Right : Object)
      return        Types.Abscissa;

   Location_Are_Not_Comparable : exception;

private

   type Object is new Location.Object with record
      Reference_Extremity : Segment.Extremity;
   end record;

end Location.Oriented;
