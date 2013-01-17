with Segment;

package body Zone is

   function Create
     (Start : Location.Oriented.Object;
      Length : Types.Length)
      return Object
   is
   begin
      return Object'(
                     Start => Start,
                     Length => Length
                    );
   end Create;

   function Zero (This : Object)
                 return Location.Oriented.Object
   is
   begin
      return Location.Oriented.Create
        ( This.Start.Non_Oriented,
          Segment.Opposite_Extremity (This.Start.Extremity)
        );
   end Zero;

   function Max (This : Object; Current_Track : Track.Object)
                return Location.Oriented.Object is
   begin
      return Location.Oriented.Add
        (Current_Track, This.Start, This.Length);
   end Max;

end Zone;
