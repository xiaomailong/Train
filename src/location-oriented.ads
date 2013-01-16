package Location.Oriented is

   type Object is new Location.Object with private;

   function Non_Oriented (This : Object) return Location.Object;

   function Create (
                    Non_Oriented : Location.Object;
                    Extremity : Segment.Extremity := Segment.Incrementing
                   )
                   return Object;

   function Create (
                    Relative : Segment.Vectors.Cursor;
                    Abscissa : Types.Abscissa
                   )
                   return Object;
   function Create (
                    Relative : Segment.Vectors.Cursor;
                    Abscissa : Types.Abscissa;
                    Extremity : Segment.Extremity := Segment.Incrementing
                   )
                   return Object;

   function Extremity (This : Object)
                     return Segment.Extremity;
   function Extremity (
                      This : Object;
                      Dynamic_Track : Track.Object;
                      Relative : in Segment.Vectors.Cursor
                     )
                     return Segment.Extremity;

   function Normalize (This : Object; Current_Track : Track.Object)
                      return Object;

   function Same_Extremity (Current_Track : Track.Object; Left, Right : Object)
                           return Boolean;

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

   Location_Are_Not_Comparable : exception;

private

   type Object is new Location.Object with
      record
         Reference_Extremity : Segment.Extremity;
      end record;

end Location.Oriented;
