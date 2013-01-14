with Switch;
with Switch.Vectors;

package Track.Switch_Operations is

   procedure Unset (This : in out Object; S : Switch.Vectors.Cursor);
   procedure Set (
                  This : in out Object;
                  S : Switch.Vectors.Cursor;
                  Switch_Position : Switch.Position);

end Track.Switch_Operations;
