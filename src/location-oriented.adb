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

package body Location.Oriented is

   function Non_Oriented (This : Object) return Location.Object is
   begin
      return Location.Object'(This.Reference, This.Abscissa);
   end Non_Oriented;

   function Create
     (Non_Oriented : Location.Object;
      Extremity    : Segment.Extremity := Segment.Incrementing)
      return         Object
   is
   begin
      return Object'(Non_Oriented with Reference_Extremity => Extremity);
   end Create;

   function Create
     (Relative  : Segment.Vectors.Cursor;
      Abscissa  : Types.Abscissa;
      Extremity : Segment.Extremity := Segment.Incrementing)
      return      Object
   is
   begin
      return Object'(Location.Create (Relative, Abscissa) with
        Reference_Extremity => Extremity);
   end Create;

   function Create
     (Relative : Segment.Vectors.Cursor;
      Abscissa : Types.Abscissa)
      return     Object
   is
   begin
      return Create (Relative, Abscissa, Segment.Incrementing);
   end Create;

   function Opposite (This : Location.Oriented.Object) return Object is
   begin
      return Create
               (This.Non_Oriented,
                Segment.Opposite_Extremity (This.Reference_Extremity));
   end Opposite;

   function Extremity (This : Object) return Segment.Extremity is
   begin
      return This.Reference_Extremity;
   end Extremity;

   function Extremity
     (This          : Object;
      Dynamic_Track : Track.Object;
      Relative      : in Segment.Vectors.Cursor)
      return          Segment.Extremity
   is
   begin
      return Dynamic_Track.Relative_Extremity
               (Relative,
                This.Reference,
                This.Extremity);
   end Extremity;

   function Normalize (This : Object) return Object is
      Normalized_Non_Oriented : constant Location.Object :=
         Location.Normalize (Non_Oriented (This));
   begin
      return Create
               (Normalized_Non_Oriented,
                Current_Track.all.Relative_Extremity
                   (Normalized_Non_Oriented.Reference,
                    This.Reference,
                    This.Reference_Extremity));
   end Normalize;

   function Comparable (Left, Right : Object) return Boolean is
   begin
      return Same_Extremity (Left, Right)
            and then Comparable (Left.Non_Oriented, Right.Non_Oriented);
   end Comparable;

   function Same_Extremity (Left, Right : Object) return Boolean is
      use type Segment.Extremity;
   begin
      return Left.Extremity =
             Current_Track.all.Relative_Extremity
                (Left.Reference,
                 Right.Reference,
                 Right.Extremity);
   end Same_Extremity;

   function Equal (Left, Right : Object) return Boolean is
   begin
      return Equal (Non_Oriented (Left), Non_Oriented (Right)) and
             Same_Extremity (Left, Right);
   end Equal;

   function LowerThan
     (Reference   : Segment.Vectors.Cursor;
      Left, Right : Object)
      return        Boolean
   is
   begin
      if not Same_Extremity (Left, Right)
      then
         raise Location_Are_Not_Comparable;
      end if;

      return LowerThan (Reference, Non_Oriented (Left), Non_Oriented (Right));
   end LowerThan;

   function LowerThan (Left, Right : Object) return Boolean is
   begin
      if not Same_Extremity (Left, Right)
      then
         raise Location_Are_Not_Comparable;
      end if;

      case Left.Reference_Extremity is
         when Segment.Incrementing =>
            return LowerThan
                     (Left.Reference,
                      Non_Oriented (Left),
                      Non_Oriented (Right));
         when Segment.Decrementing =>
            return LowerThan
                     (Left.Reference,
                      Non_Oriented (Right),
                      Non_Oriented (Left));
      end case;
   end LowerThan;

   function Add
     (Reference : Segment.Vectors.Cursor;
      Left      : Object;
      Right     : Types.Abscissa)
      return      Object
   is
      Normalized_Non_Oriented : constant Location.Object :=
         Location.Add (Reference, Non_Oriented (Left), Right);
   begin
      return Create
               (Normalized_Non_Oriented,
                Current_Track.all.Relative_Extremity
                   (Normalized_Non_Oriented.Reference,
                    Left.Reference,
                    Left.Reference_Extremity));
   end Add;

   function Add (Left : Object; Right : Types.Abscissa) return Object is
      use type Types.Meter_Precision_Millimeter;
   begin
      case Left.Reference_Extremity is
         when Segment.Incrementing =>
            return Add (Left.Reference, Left, Right);
         when Segment.Decrementing =>
            return Add (Left.Reference, Left, -Right);
      end case;
   end Add;

   function Minus (Left, Right : Object) return Types.Abscissa is
   begin
      if not Same_Extremity (Left, Right)
      then
         raise Location_Are_Not_Comparable;
      end if;

      return Minus (Non_Oriented (Left), Non_Oriented (Right));
   end Minus;

end Location.Oriented;
