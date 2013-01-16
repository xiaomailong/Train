package body Location.Topo is

   function "=" (Left, Right : Object) return Boolean is
   begin
      return Equal (Current_Track, Left, Right);
   end "=";

   function ">" (Left, Right : Object) return Boolean is
   begin
      return Lowerthan (Current_Track, Left, Right);
   end ">";

   function "+" (Left : Object; Right : Types.Abscissa) return Object is
   begin
      return Add (Current_Track, Left, Right);
   end "+";

   function "-" (Left : Object; Right : Types.Abscissa) return Object is
      use type Types.Meter_Precision_Millimeter;
   begin
      return Add (Current_Track, Left, -Right);
   end "-";

   function "-" (Left, Right : Object) return Types.Abscissa is
   begin
      return Minus (Current_Track, Left, Right);
   end "-";

end Location.Topo;
