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
