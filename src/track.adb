package body Track is

   function Create return Object is
   begin
      return Object'(
                     Segments => Segment.Vectors.Empty_Vector,
                     Switchs => Switch.Vectors.Empty_Vector
                    );
   end Create;

   procedure Add_Unlinked_Segment
     (This : in out Object;
      New_Segment : Segment.Object;
      Cursor : out Segment.Vectors.Cursor
     )
   is
      use type Segment.Vectors.Vector;
   begin
      This.Segments := This.Segments & New_Segment;
      Cursor :=  This.Segments.Last;
   end Add_Unlinked_Segment;

   procedure Add_Switch
     (This : in out Object;
      New_Switch : Switch.Object;
      Cursor : out Switch.Vectors.Cursor
     )
   is
      use type Switch.Vectors.Vector;
   begin
      This.Switchs := This.Switchs & New_Switch;
      Cursor := This.Switchs.Last;
   end Add_Switch;

   procedure Add_Link (
                       This : in out Object;
                       S1 : Segment.Vectors.Cursor;
                       S1_Extremity : Segment.Extremity;
                       Link_Switch : Switch.Vectors.Cursor;
                       Link_Position : Switch.Position;
                       S2 : Segment.Vectors.Cursor;
                       S2_Extremity : Segment.Extremity
                      )
   is
      Actual_Switch : Switch.Object := Switch.Vectors.Element(Link_Switch);
   begin
      Actual_Switch.Add_Branch (
                                S1,
                                S1_Extremity,
                                Link_Position,
                                S2,
                                S2_Extremity
                               );
      This.Switchs.Replace_Element (Link_Switch, Actual_Switch);
   end Add_Link;

   procedure Next (
                   This : in Object;
                   S : in out Segment.Vectors.Cursor;
                   S_Extremity : in out Segment.Extremity
                  )
   is

      Found : Boolean := False;
      procedure Switch_Lookout (Position : in Switch.Vectors.Cursor)
      is
         use type Segment.Vectors.Cursor;
         use type Segment.Extremity;
         Element : constant Switch.Object := Switch.Vectors.Element(Position);
      begin
         if Element.Connexion.S1 = S
           and Element.Connexion.S1_Extremity = S_Extremity
         then
            Found := True;
            S := Element.Connexion.S2;
            S_Extremity := Element.Connexion.S2_Extremity;
         elsif Element.Connexion.S2 = S
           and Element.Connexion.S2_Extremity = S_Extremity
         then
            Found := True;
            S := Element.Connexion.S1;
            S_Extremity := Element.Connexion.S1_Extremity;
         end if;

      exception
         when Switch.Unset_Switch =>
            null;
      end Switch_Lookout;

   begin
      This.Switchs.Iterate (Switch_Lookout'access);

      -- Be careful, we got the extremity linked by the switch,
      -- not the extremity in the same global direction than input.
      -- We need to get the opposite one.
      S_Extremity := Segment.Opposite_Extremity (S_Extremity);

      if not Found then
         raise No_Next_Segment;
      end if;
   end Next;

end Track;
