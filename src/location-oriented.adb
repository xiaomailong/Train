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

   function Non_Oriented (This : Object) return Location.Object
   is
   begin
      return Location.Object'(This.Reference, This.Abscissa);
   end Non_Oriented;

   function Create (
                    Non_Oriented : Location.Object;
                    Extremity : Segment.Extremity := Segment.Incrementing
                   )
                   return Object
   is
   begin
      return Object'(Non_Oriented with Reference_Extremity => Extremity);
   end Create;

   function Create
     (Relative : Segment.Vectors.Cursor;
      Abscissa : Types.Abscissa;
      Extremity : Segment.Extremity := Segment.Incrementing)
      return Object
   is
   begin
      return Object'(Location.Create (Relative, Abscissa) with
                       Reference_Extremity => Extremity);
   end Create;

   function Create
     (Relative : Segment.Vectors.Cursor;
      Abscissa : Types.Abscissa)
     return Object
   is
   begin
      return Create (Relative, Abscissa, Segment.Incrementing);
   end Create;

   function Extremity (This : Object)
                     return Segment.Extremity
   is
   begin
      return This.Reference_Extremity;
   end Extremity;

   function Extremity (
                      This : Object;
                      Dynamic_Track : Track.Object;
                      Relative : in Segment.Vectors.Cursor
                     )
                     return Segment.Extremity
   is
   begin
      return Dynamic_Track.Relative_Extremity ( Relative,
                                                This.Reference,
                                                This.Extremity
                                              );
   end Extremity;

   function Normalize (This : Object; Current_Track : Track.Object)
                      return Object
   is
      Normalized_Non_Oriented : constant Location.Object
        := Location.Normalize (Non_Oriented (This), Current_Track);
   begin
      return Create (Normalized_Non_Oriented,
                     Current_Track.Relative_Extremity
                       (
                        Normalized_Non_Oriented.Reference,
                        This.Reference,
                        This.Reference_Extremity
                       )
                    );
   end Normalize;

   function Comparable (Current_Track : Track.Object; Left, Right : Object)
                       return Boolean
   is
   begin
      return Same_Extremity (Current_Track, Left, Right)
        and then Comparable
        (Current_Track, Left.Non_Oriented, Right.Non_Oriented);
   end Comparable;

   function Same_Extremity (Current_Track : Track.Object; Left, Right : Object)
                           return Boolean
   is
      use type Segment.Extremity;
   begin
      return Left.Extremity = Current_Track.Relative_Extremity (
                                                               Left.Reference,
                                                               Right.Reference,
                                                               Right.Extremity
                                                               );
   end Same_Extremity;

   function Equal (Current_Track : Track.Object; Left, Right : Object)
                  return Boolean
   is
   begin
      return Equal (Current_Track, Non_Oriented (Left), Non_Oriented (Right))
        and Same_Extremity (Current_Track, Left, Right);
   end Equal;

   function LowerThan (
                       Current_Track : Track.Object;
                       Reference : Segment.Vectors.Cursor;
                       Left, Right : Object
                      )
                      return Boolean
   is
   begin
      if not Same_Extremity (Current_Track, Left, Right)
      then
         raise Location_Are_Not_Comparable;
      end if;

      return LowerThan (Current_Track, Reference,
                        Non_Oriented (Left), Non_Oriented (Right));
   end LowerThan;

   function LowerThan (Current_Track : Track.Object; Left, Right : Object)
                      return Boolean
   is
   begin
      if not Same_Extremity (Current_Track, Left, Right)
      then
         raise Location_Are_Not_Comparable;
      end if;

      case Left.Reference_Extremity is
         when Segment.Incrementing =>
            return LowerThan (Current_Track, Left.Reference,
                              Non_Oriented (Left), Non_Oriented (Right));
         when Segment.Decrementing =>
            return LowerThan (Current_Track, Left.Reference,
                              Non_Oriented (Right), Non_Oriented (Left));
      end case;
   end LowerThan;


   function Add (
                 Current_Track : Track.Object;
                 Reference : Segment.Vectors.Cursor;
                 Left : Object;
                 Right : Types.Abscissa
                )
                return Object
   is
      Normalized_Non_Oriented : constant Location.Object
        := Location.Add (Current_Track, Reference, Non_Oriented (Left), Right);
   begin
      return Create  (Normalized_Non_Oriented,
                      Current_Track.Relative_Extremity
                        (
                         Normalized_Non_Oriented.Reference,
                         Left.Reference,
                         Left.Reference_Extremity
                        )
                     );
   end Add;

   function Add (
                 Current_Track : Track.Object;
                 Left : Object;
                 Right : Types.Abscissa
                )
                return Object
   is
      use type Types.Meter_Precision_Millimeter;
   begin
      case Left.Reference_Extremity is
         when Segment.Incrementing =>
            return Add (Current_Track, Left.Reference, Left, Right);
         when Segment.Decrementing =>
            return Add (Current_Track, Left.Reference, Left, - Right);
      end case;
   end Add;

   function Minus (
                   Current_Track : Track.Object;
                   Left, Right : Object
                  )
                  return Types.Abscissa
   is
   begin
      if not Same_Extremity (Current_Track, Left, Right)
      then
         raise Location_Are_Not_Comparable;
      end if;

      return Minus (Current_Track,
                        Non_Oriented (Left), Non_Oriented (Right));
   end Minus;


end Location.Oriented;
