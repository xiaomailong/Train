package body Location.Topo is

   function "=" (Left, Right : Object'Class) return Boolean is
   begin
      return Equal (Current_Track.all, Left, Right);
   end "=";

   function "<" (Left, Right : Object'Class) return Boolean is
   begin
      return Lowerthan (Current_Track.all, Left, Right);
   end "<";

   function "+" (Left : Object'Class; Right : Types.Abscissa) return Object'Class is
   begin
      return Add (Current_Track.all, Left, Right);
   end "+";

   function "-" (Left : Object'Class; Right : Types.Abscissa) return Object'Class is
      use type Types.Meter_Precision_Millimeter;
   begin
      return Add (Current_Track.all, Left, -Right);
   end "-";

   function "-" (Left, Right : Object'Class) return Types.Abscissa is
   begin
      return Minus (Current_Track.all, Left, Right);
   end "-";

end Location.Topo;
