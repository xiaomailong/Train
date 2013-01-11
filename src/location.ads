with Types;
with Segment.Vectors;
with Track;

package Location is

   type Object is tagged private;

   function Create (
                    Relative : Segment.Vectors.Cursor;
                    Abscissa : Types.Abscissa
                   )
     return Object;

   function Abscissa (This : Object)
                     return Types.Abscissa;
   function Abscissa (This : Object; Relative : in Segment.Vectors.Cursor)
                     return Types.Abscissa;
   function Abscissa (
                      This : Object;
                      Dynamic_Track : Track.Object;
                      Relative : in Segment.Vectors.Cursor
                     )
                     return Types.Abscissa;
   function Reference (This : Object)
                    return Segment.Vectors.Cursor;

   -- Equal position if abscissa relatively to same segment are equal, with
   -- unit precision
   generic
      Current_Track : Track.Object;
   function equal (A : Object; B : Object) return Boolean;

   -- Exceptions

   No_Link_With_Segment : exception;

private
   type Object is tagged
      record
         Reference_Segment : Segment.Vectors.Cursor;
         Reference_Abscissa : Types.Abscissa;
      end record;

end Location;
