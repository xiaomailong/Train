with Types;

package Segment is

   type Object is tagged private;

   type Extremity is (Decrementing, Incrementing);

   function Create (
                    Length : Types.Length
                   )
                   return Object;

   function Max_Abscissa (This : Object) return Types.Length;

private

   type Object is tagged
      record
         Max_Abscissa : Types.Length;
      end record;
end Segment;
