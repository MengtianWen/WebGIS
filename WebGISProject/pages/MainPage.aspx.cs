using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;


namespace WebGISProject
{
    public partial class DBOperation : System.Web.UI.Page
    {
        //类型的字符串
        private List<string> types=new List<string>();

        protected void Page_Load(object sender, EventArgs e)
        { 
           
        }

        //查询
        protected void btn_Query_Click(object sender, EventArgs e)
        {
            string pnt_type = ddl_type.SelectedItem.Text;;
            string pnt_name = txt_name.Text;
           
                string selectStr = "";
                if(pnt_name==""||pnt_name=="全部")
                {
                    if (pnt_type == "全部")//查询全部类型的全部点
                    {
                        selectStr = "select * from point;";
                    }
                    else            //查询某个类型的全部点
                    {
                        selectStr = "select * from point where pnt_type='" + pnt_type + "';";
                    }
                }
                else
                {
                    if (pnt_type == "全部")    //查询全部类型中的某个点；
                    {
                        selectStr = "select * from point where pnt_name='"+pnt_name+"';";
                    }
                    else                    //查询某个类型的某个点；
                    {
                        selectStr = "select * from point where pnt_type='" + pnt_type + "' and pnt_name='" + pnt_name + "';";
                    }
                }
                this.DBGIS.SelectCommand = selectStr;
           
        }

        protected void ddl_type_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                types.Add("全部");
                string connStr = "Data Source=.;Initial Catalog=GIS;User ID=WMT;Password=wenmengtian";
                SqlConnection conn = new SqlConnection(connStr);
                try
                {
                    if (conn.State == ConnectionState.Open)
                    {
                        conn.Close();
                    }
                    conn.Open();//打开连接

                    string selectStr = "select distinct pnt_type from point;";
                    SqlCommand selectCmd = new SqlCommand(selectStr, conn);
                    SqlDataReader dr = selectCmd.ExecuteReader();
                    string ti = "";
                    while (dr.Read())
                    {
                        ti = dr["pnt_type"].ToString();
                        types.Add(ti);
                    }
                    ddl_type.DataSource = types;
                    ddl_type.DataBind();

                    dr.Close();
                    conn.Close();
                }
                catch (SqlException)
                {
                    Response.Write("<script>alert('初始化错误！');</script>");
                }
            }
        }
        
    }
}