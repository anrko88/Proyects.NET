
namespace Business.Aplication_Categories
{
    public  class BECategorias
    {
        private int categoryID;

        public int CategoryID
        {
            get { return categoryID; }
            set { categoryID = value; }
        }
        private string categoryName;

        public string CategoryName
        {
            get { return categoryName; }
            set { categoryName = value; }
        }
        private string description;

        public string Description
        {
            get { return description; }
            set { description = value; }
        }
    }
}
