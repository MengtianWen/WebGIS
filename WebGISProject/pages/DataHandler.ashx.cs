using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;

namespace WebGISProject.pages
{
    /// <summary>
    /// DataHandler 的摘要说明
    /// </summary>
    public class DataHandler : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            //------------------------------------
            context.Response.ContentType = "text/plain";
            string type = context.Request.Form["type"];
            string geo = context.Request.Form["geo"];
            string name = context.Request.Form["name"];
            string attribute = context.Request.Form["att"];

            string[] arrTemp = geo.Split(';');
            double x = Convert.ToDouble(arrTemp[0]);
            double y = Convert.ToDouble(arrTemp[1]);

            string connStr = "Data Source=.;Initial Catalog=GIS;User ID=WMT;Password=wenmengtian";
            SqlConnection conn = new SqlConnection(connStr);
            try
            {
                if (conn.State == ConnectionState.Open)
                {
                    conn.Close();
                }
                conn.Open();//打开连接

                string insertStr = "insert into point (pnt_x,pnt_y,pnt_type,pnt_name,pnt_attribute) values("+x+","+y+",'"+type+"','"+name+"','"+attribute+"');";
                SqlCommand insertCmd = new SqlCommand(insertStr, conn);
                int updateCount = insertCmd.ExecuteNonQuery();
                if(updateCount==1)
                {
                    context.Response.Write("数据保存成功！");
                }
                else
                {
                    context.Response.Write("数据保存失败！");
                }
                
            }
            catch (SqlException e)
            {
                string message = "数据保存失败" + e.Message;
                context.Response.Write(message);
            }
            finally
            {
                if(conn.State==ConnectionState.Open)
                    conn.Close();
            }

        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}