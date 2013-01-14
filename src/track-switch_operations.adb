package body Track.Switch_Operations is

   procedure Unset (This : in out Object; S : Switch.Vectors.Cursor) is
      Switch_Element : Switch.Object := Switch.Vectors.Element (S);
   begin
      Switch_Element.Unset;
      Switch.Vectors.Replace_Element (This.Switchs, S, Switch_Element);
   end Unset;

   procedure Set
     (This : in out Object;
      S : Switch.Vectors.Cursor;
      Switch_Position : Switch.Position)
   is
      Switch_Element : Switch.Object := Switch.Vectors.Element (S);
   begin
      Switch_Element.Set (Switch_Position);
      Switch.Vectors.Replace_Element (This.Switchs, S, Switch_Element);
   end Set;

end Track.Switch_Operations;
