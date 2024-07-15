using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;
public partial class Crud_operations : System.Web.UI.Page
{
    public static string data { set; get; }

    CommonClass Comman = new CommonClass();
    CommFuncs mclsCFunc = new CommFuncs();

    PodClose_Cls PodCls = new PodClose_Cls();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["Whmcode"] == null || Session["Userid"] == null || Session["ClntCode"] == null || Session["Trdate"] == null || Session["UserCat"] == null)
        {
            Response.Redirect("~/login.aspx");
            return;
        }

        if (!this.IsPostBack)
        {
            if (Session["CurrentPageIndex"] != null)
            {
                Gdv_PODPndApprvl.PageIndex = (int)Session["CurrentPageIndex"];
                Txtemp_id.Enabled = false;
            }


            this.BindGrid();
            UpdateDisplay();

        }

    }


    protected void ddlOptions_SelectedIndexChanged(object sender, EventArgs e)
    {
        UpdateDisplay();
    }


    private void UpdateDisplay()
    {
        if (ddlOptions.SelectedValue == "2")
        {
            full_div.Style["display"] = "block";
            CANCEL_BUTT.Style["display"] = "block";
            ADD.Style["display"] = "block";
            cancelbut.Style["display"] = "none";
            save_but.Style["display"] = "none";
            Gdv_PODPndApprvl.Style["display"] = "none";
            drop_down.Style["display"] = "none";
            int nextEmployeeId = GetNextEmployeeId();
            Txtemp_id.Text = nextEmployeeId.ToString();
            lblMessage.Visible = false;
        }
        else
        {
            full_div.Style["display"] = "none";

        }
    }


    protected void OnPageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        Gdv_PODPndApprvl.PageIndex = e.NewPageIndex;
        Session["CurrentPageIndex"] = e.NewPageIndex;
        this.BindGrid();
    }



    protected void OnSorting(object sender, GridViewSortEventArgs e)
    {
        this.BindGrid(e.SortExpression);
    }



    private string SortDirection
    {
        get { return ViewState["SortDirection"] != null ? ViewState["SortDirection"].ToString() : "ASC"; }
        set { ViewState["SortDirection"] = value; }
    }







    private void BindGrid(string sortExpression = null)
    {
        string constr = ConfigurationManager.ConnectionStrings["constr"].ConnectionString;
        using (SqlConnection con = new SqlConnection(constr))
        {
            using (SqlCommand cmd = new SqlCommand("EXEC CRUDOPERATION_SP " + 20216 + ",'P','' "))
            {
                using (SqlDataAdapter sda = new SqlDataAdapter())
                {
                    cmd.Connection = con;
                    sda.SelectCommand = cmd;
                    using (DataTable dt = new DataTable())
                    {
                        sda.Fill(dt);
                        if (sortExpression != null)
                        {
                            DataView dv = dt.AsDataView();
                            this.SortDirection = this.SortDirection == "ASC" ? "DESC" : "ASC";

                            dv.Sort = sortExpression + " " + this.SortDirection;
                            Gdv_PODPndApprvl.DataSource = dv;
                        }
                        else
                        {
                            Gdv_PODPndApprvl.DataSource = dt;

                        }
                        Gdv_PODPndApprvl.Font.Size = FontUnit.XSmall;
                        Gdv_PODPndApprvl.DataBind();
                    }
                }
            }
        }
    }



    protected void Gdv_PODPndApprvl_RowEditing(object sender, GridViewEditEventArgs e)
    {
        GridViewRow row = Gdv_PODPndApprvl.Rows[e.NewEditIndex];
        string employeeId = ((Label)row.FindControl("lblEmployeeId")).Text;
        string employeeName = ((Label)row.FindControl("lblEmployeeName")).Text;
        string designation = ((Label)row.FindControl("lblDesignation")).Text;
        string post = ((Label)row.FindControl("lblPost")).Text;
        string place = ((Label)row.FindControl("lblPlace")).Text;
        string phone = ((Label)row.FindControl("lblPhone")).Text;

        ScriptManager.RegisterStartupScript(this, GetType(), "PopulateFields",
            String.Format("handleEditButtonClick('{0}', '{1}', '{2}', '{3}', '{4}', '{5}');",
                employeeId, employeeName, designation, post, place, phone), true);
    }





    protected void RedirectToBackbutton_Click(object sender, EventArgs e)
    {
        Response.Redirect("Crud_operations.aspx", false);
    }




    protected void save_but_Click(object sender, EventArgs e)
    {
        string employeeId = Txtemp_id.Text;
        string employeeName = txtemp_name.Text;
        string designation = TextDESIGNATION.Text;
        string post = TextPOST.Text;
        string place = PLACE_num.Text;
        string phone = TextPHONE.Text;


        string constr = ConfigurationManager.ConnectionStrings["constr"].ConnectionString;
        using (SqlConnection connection = new SqlConnection(constr))
        {
            string query = "UPDATE CRUD_OPERATION_TABLE SET EMPLOYEE_NAME = @EmployeeName, DESIGNATION = @Designation, POST = @Post, PLACE = @Place, PHONE = @Phone WHERE EMPLOYEE_ID = @EmployeeId";

            SqlCommand command = new SqlCommand(query, connection);
            command.Parameters.AddWithValue("@EmployeeName", employeeName);
            command.Parameters.AddWithValue("@Designation", designation);
            command.Parameters.AddWithValue("@Post", post);
            command.Parameters.AddWithValue("@Place", place);
            command.Parameters.AddWithValue("@Phone", phone);
            command.Parameters.AddWithValue("@EmployeeId", employeeId);
            connection.Open();
            int rowsAffected = command.ExecuteNonQuery();
            connection.Close();
            if (rowsAffected > 0)
            {
                lblMessage.Text = "Updated successfully....";
                lblMessage.Visible = true;

                const int duration = 500;
                string script = String.Format("setTimeout(function(){{ document.getElementById('{0}').style.display='none'; {1} }}, {2});", lblMessage.ClientID, "window.location.href='Crud_operations.aspx';", duration);
                ScriptManager.RegisterStartupScript(this, GetType(), "HideMessage", script, true);

            }
            else
            {
                lblMessage.Text = "Update failed";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                lblMessage.BackColor = System.Drawing.Color.MistyRose;
                lblMessage.Visible = true;
            }

        }
    }



    protected void Gdv_PODPndApprvl_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "DELETE")
        {
            try
            {
                int rowIndex = Convert.ToInt32(e.CommandArgument);
                if (rowIndex >= 0 && rowIndex < Gdv_PODPndApprvl.Rows.Count)
                {
                    string employeeId = Gdv_PODPndApprvl.DataKeys[rowIndex].Value.ToString();
                    string constr = ConfigurationManager.ConnectionStrings["constr"].ConnectionString;

                    using (SqlConnection connection = new SqlConnection(constr))
                    {
                        string query = "DELETE FROM CRUD_OPERATION_TABLE WHERE EMPLOYEE_ID = @EmployeeId";
                        SqlCommand command = new SqlCommand(query, connection);
                        command.Parameters.AddWithValue("@EmployeeId", employeeId);
                        connection.Open();
                        int rowsAffected = command.ExecuteNonQuery();
                        connection.Close();

                        if (rowsAffected > 0)
                        {
                            ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Deleted successfully.');", true);

                            Response.AppendHeader("Refresh", "3;url=Crud_operations.aspx");
                        }
                        else
                        {
                            lblMessage.Text = "Delete operation failed.";
                            lblMessage.Visible = true;
                        }

                        BindGrid();
                    }
                }
                else
                {
                    lblMessage.Text = "Error: Row index out of range.";
                    lblMessage.Visible = true;
                }
            }
            catch (FormatException)
            {
                lblMessage.Text = "Error: Invalid row index format.";
                lblMessage.Visible = true;
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error: " + ex.Message;
                lblMessage.Visible = true;
            }
        }
    }

    private int GetNextEmployeeId()
    {
        int nextEmployeeId = 0;
        string constr = ConfigurationManager.ConnectionStrings["constr"].ConnectionString;
        using (SqlConnection connection = new SqlConnection(constr))
        {
            string query = "SELECT MAX(EMPLOYEE_ID) FROM CRUD_OPERATION_TABLE";
            SqlCommand command = new SqlCommand(query, connection);
            connection.Open();
            object result = command.ExecuteScalar();
            if (result != DBNull.Value && result != null)
            {
                nextEmployeeId = Convert.ToInt32(result) + 1;
            }
            else
            {
                nextEmployeeId = 1;
            }
            connection.Close();
        }
        return nextEmployeeId;
    }

    protected void add_but_Click(object sender, EventArgs e)
    {
        try
        {
            int employeeId = GetNextEmployeeId();
            string employeeName = txtemp_name.Text;
            string designation = TextDESIGNATION.Text;
            string post = TextPOST.Text;
            string place = PLACE_num.Text;
            string phone = TextPHONE.Text;

            string constr = ConfigurationManager.ConnectionStrings["constr"].ConnectionString;
            using (SqlConnection connection = new SqlConnection(constr))
            {
                SqlCommand command = new SqlCommand("CRUDOPERATION_SP", connection);
                command.CommandType = CommandType.StoredProcedure;

                command.Parameters.AddWithValue("@WhmCode", 0);
                command.Parameters.AddWithValue("@Status", 'I');
                command.Parameters.AddWithValue("@Filter", string.Empty);
                command.Parameters.AddWithValue("@EMPLOYEE_ID", employeeId);
                command.Parameters.AddWithValue("@EMPLOYEE_NAME", employeeName);
                command.Parameters.AddWithValue("@DESIGNATION", designation);
                command.Parameters.AddWithValue("@POST", post);
                command.Parameters.AddWithValue("@PLACE", place);
                command.Parameters.AddWithValue("@PHONE", phone);

                connection.Open();
                command.ExecuteNonQuery();
                connection.Close();
                string script = @"
                alert('Inserted successfully.');
                window.location.href = 'Crud_operations.aspx';";
                ScriptManager.RegisterStartupScript(this, GetType(), "ShowSuccessAlert", script, true);

            }

            BindGrid();
        }
        catch (Exception ex)
        {
            lblMessage.Text = "Error: " + ex.Message;
            lblMessage.Visible = true;
        }
    }

}