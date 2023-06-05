namespace Business
{
    static class Cls_Conexion
    {
       
        public static string cn_Northwind
        {
            get
            {
                return "Server=localhost;Integrated Security=SSPI;Database=Northwind";
            }
        }

        public static string cn_Pubs
        {
            get {
                return "server=localhost;integrated security=SSPI;database=pubs";
            }
        }
    }
}
