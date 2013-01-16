with Segment;
with Segment.Vectors;
with Switch;
with Switch.Vectors;

package Track is

   type Object is tagged private;

   function Create return Object;

   -- Create track by adding and linking components

   procedure Add_Unlinked_Segment (
                                   This : in out Object;
                                   New_Segment : Segment.Object;
                                   Cursor : out Segment.Vectors.Cursor
                                  );

   procedure Add_Switch (
                         This : in out Object;
                         New_Switch : Switch.Object;
                         Cursor : out Switch.Vectors.Cursor
                        );

   procedure Add_Link (
                       This : in out Object;
                       S1 : Segment.Vectors.Cursor;
                       S1_Extremity : Segment.Extremity;
                       Link_Switch : Switch.Vectors.Cursor;
                       Link_Position : Switch.Position;
                       S2 : Segment.Vectors.Cursor;
                       S2_Extremity : Segment.Extremity
                      );

   -- Get track objects

   function Element (
                     S : Segment.Vectors.Cursor
                    )
                    return Segment.Object;
   function Element (
                     S : Switch.Vectors.Cursor
                    )
                    return Switch.Object;

   procedure Next (
                   This : in Object;
                   S : in out Segment.Vectors.Cursor;
                   S_Extremity : in out Segment.Extremity
                  );

   function Relative_Extremity (
                                This : Object;
                                Reference : Segment.Vectors.Cursor;
                                Location : Segment.Vectors.Cursor;
                                Location_Extremity : Segment.Extremity
                               )
                               return Segment.Extremity;

   procedure End_Of_Route (
                           This : Object;
                           S : in out Segment.Vectors.Cursor;
                           S_Extremity : in out Segment.Extremity
                       );

   -- Switch operations
   procedure Unset (This : in out Object; S : Switch.Vectors.Cursor);
   procedure Set (
                  This : in out Object;
                  S : Switch.Vectors.Cursor;
                  Switch_Position : Switch.Position);

   No_Next_Segment : exception;
   Unexpected_Loop : exception;

private

   type Object is tagged
      record
         Segments : Segment.Vectors.Vector;
         Switchs : Switch.Vectors.Vector;
      end record;

end Track;
