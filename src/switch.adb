package body Switch is

   function Create return Object is
   begin
      return Object'
        (
         Is_Set => False,
         Current_Position => Position'Last,
         Branches => Branches_Map.Empty_Map
        );
   end Create;

   ----------------
   -- Add_Branch --
   ----------------

   procedure Add_Branch
     (
      This : in out Object;
      S1 : Segment.Vectors.Cursor;
      S1_Extremity : Segment.Extremity;
      Switch_Position : Position;
      S2 : Segment.Vectors.Cursor;
      S2_Extremity : Segment.Extremity
     )
   is
   begin
      This.Branches.Include (
                             Key => Switch_Position,
                             New_Item => Link'(
                                               S1 => S1,
                                               S1_Extremity => S1_Extremity,
                                               S2 => S2,
                                               S2_Extremity => S2_Extremity
                                              )
                            );
   end Add_Branch;

   procedure Unset (This : in out Object) is
   begin
      This.Is_Set := False;
   end Unset;

   procedure Set
     (This : in out Object;
      Switch_Position : Position)
   is
   begin
      This.Is_Set := True;
      This.Current_Position := Switch_Position;
   end Set;

   function Id (Key : Position) return Ada.Containers.Hash_Type is
   begin
      return  Ada.Containers.Hash_Type(Key);
   end Id;

   function Connexion(This : Object) return Link
   is
   begin
      if This.Is_Set then
         return This.Branches.Element (This.Current_Position);
      else
         raise Unset_Switch;
      end if;
   end Connexion;

end Switch;
