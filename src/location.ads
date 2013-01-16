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
   function Abscissa (
                      This : Object;
                      Dynamic_Track : Track.Object;
                      Relative : in Segment.Vectors.Cursor
                     )
                     return Types.Abscissa;
   function Reference (This : Object)
                      return Segment.Vectors.Cursor;

   -- Topological  functions

   -- Be carefull, topological functions depends on current switch positions

   -- When no reference segment is given, first operand is choosen as reference

   function Normalize (This : Object; Current_Track : Track.Object)
                      return Object;

   function Equal (Current_Track : Track.Object; Left, Right : Object)
                  return Boolean;

   function LowerThan (
                       Current_Track : Track.Object;
                       Reference : Segment.Vectors.Cursor;
                       Left, Right : Object
                      )
                      return Boolean;

   function LowerThan (Current_Track : Track.Object; Left, Right : Object)
                      return Boolean;

   function Add (
                 Current_Track : Track.Object;
                 Reference : Segment.Vectors.Cursor;
                 Left : Object;
                 Right : Types.Abscissa
                )
                return Object;

   function Add (
                 Current_Track : Track.Object;
                 Left : Object;
                 Right : Types.Abscissa
                )
                return Object;

   function Minus (
                   Current_Track : Track.Object;
                   Left, Right : Object
                  )
                  return Types.Abscissa;

   -- Exceptions

   No_Link_With_Segment : exception;

private
   type Object is tagged
      record
         Reference_Segment : Segment.Vectors.Cursor;
         Reference_Abscissa : Types.Abscissa;
      end record;

end Location;
