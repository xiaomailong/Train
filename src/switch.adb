--  Copyright \copy 2013 Baptiste Fouques

--  This program  is free  software: you  can redistribute  it and/or  modify it
--  under the terms of  the GNU General Public License as  published by the Free
--  Software Foundation,  either version 3 of  the License, or (at  your option)
--  any later version.

--  This program is distributed in the hope  that it will be useful, but WITHOUT
--  ANY  WARRANTY;  without even  the  implied  warranty of  MERCHANTABILITY  or
--  FITNESS FOR  A PARTICULAR PURPOSE.  See  the GNU General Public  License for
--  more details.

--  You should have received a copy of the GNU General Public License along with
--  this program.  If not, see http://www.gnu.org/licenses/.

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

   function Is_Set (This : in Object) return Boolean
   is begin return This.Is_Set; end Is_Set;

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
