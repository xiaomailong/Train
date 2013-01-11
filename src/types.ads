with Constants;

package Types is

   type Index_Type is range 1 .. Constants.Number_Max_Of_Elements;

   type Meter_Precision_Millimeter is delta Constants.Millimeter range
     -Constants.Kilometer .. Constants.Kilometer;
   for Meter_Precision_Millimeter'Small use Constants.Millimeter;

   subtype Length is Meter_Precision_Millimeter range
     0.0 .. Meter_Precision_Millimeter'Last;
   subtype Abscissa is Meter_Precision_Millimeter;

end Types;
