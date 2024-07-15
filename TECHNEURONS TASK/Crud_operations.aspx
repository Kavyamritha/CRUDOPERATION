<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage_pod.master" AutoEventWireup="true" CodeFile="Crud_operations.aspx.cs" Inherits="Crud_operations" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet" />

    <script type="text/javascript">

        window.onload = function () {
            document.getElementById('<%= full_div.ClientID %>').style.display = "none";

        };

        function validateFields() {
            var isValid = true;

            var empName = document.getElementById('<%= txtemp_name.ClientID %>').value;
            var designation = document.getElementById('<%= TextDESIGNATION.ClientID %>').value;
            var post = document.getElementById('<%= TextPOST.ClientID %>').value;
            var place = document.getElementById('<%= PLACE_num.ClientID %>').value;
            var phone = document.getElementById('<%= TextPHONE.ClientID %>').value;

            if (empName.trim() === '') {
                isValid = false;
                alert('Employee Name is required.');
                document.getElementById('<%= txtemp_name.ClientID %>').focus();
            } else if (designation.trim() === '') {
                isValid = false;
                alert('Designation is required.');
                document.getElementById('<%= TextDESIGNATION.ClientID %>').focus();
            } else if (post.trim() === '') {
                isValid = false;
                alert('Post is required.');
                document.getElementById('<%= TextPOST.ClientID %>').focus();
            } else if (place.trim() === '') {
                isValid = false;
                alert('Place is required.');
                document.getElementById('<%= PLACE_num.ClientID %>').focus();
           } else if (phone.trim() === '') {
               isValid = false;
               alert('Phone is required.');
               document.getElementById('<%= TextPHONE.ClientID %>').focus();
    }

    return isValid;
}

function handleEditButtonClick(employeeId, employeeName, designation, post, place, phone) {
    document.getElementById('<%= HiddenFieldEditMode.ClientID %>').value = '1';
    document.getElementById('<%= Gdv_PODPndApprvl.ClientID %>').style.display = 'none';
    document.getElementById('<%= drop_down.ClientID %>').style.display = 'none';
    document.getElementById('<%= CANCEL_BUTT.ClientID %>').style.display = 'none';
    document.getElementById('<%= ADD.ClientID %>').style.display = 'none';
    document.getElementById('<%= full_div.ClientID %>').style.display = 'block';
    document.getElementById('<%= Txtemp_id.ClientID %>').value = employeeId;
    document.getElementById('<%= txtemp_name.ClientID %>').value = employeeName;
    document.getElementById('<%= TextDESIGNATION.ClientID %>').value = designation;
    document.getElementById('<%= TextPOST.ClientID %>').value = post;
    document.getElementById('<%= PLACE_num.ClientID %>').value = place;
    document.getElementById('<%= TextPHONE.ClientID %>').value = phone;
}


function handleDeleteButtonClick(employeeId, employeeName, designation, post, place, phone) {

    if (confirm('Are you sure you want to delete ' + employeeName + '?')) {
        alert('Deleted successfully!');
        window.location.href = 'Crud_operations.aspx';
        return true;
    }
    return false;
}


document.addEventListener('DOMContentLoaded', function () {
    var editButtons = document.querySelectorAll('#<%= Gdv_PODPndApprvl.ClientID %> input[type="button"]');
    editButtons.forEach(function (button) {
        button.addEventListener('click', function (event) {
            var employeeId = event.target.getAttribute('data-employeeId');
            var employeeName = event.target.getAttribute('data-employeeName');
            var designation = event.target.getAttribute('data-designation');
            var post = event.target.getAttribute('data-post');
            var place = event.target.getAttribute('data-place');
            var phone = event.target.getAttribute('data-phone');
            handleEditButtonClick(employeeId, employeeName, designation, post, place, phone);
        });
    });
});

function allowOnlyNumbersAndDot(event) {
    var charCode = (event.which) ? event.which : event.keyCode;
    if (charCode == 46 || (charCode >= 48 && charCode <= 57)) {
        return true;
    } else {
        event.preventDefault ? event.preventDefault() : (event.returnValue = false);
        Swal.fire({
            icon: 'warning',
            title: 'Invalid Input',
            text: 'Only dot (.) is allowed',
            showConfirmButton: false,
            timer: 1500
        });
        return false;
    }
}

function isNumberKey(evt) {
    var charCode = (evt.which) ? evt.which : event.keyCode;
    if (charCode > 31 && (charCode < 48 || charCode > 57)) {
        return false;
    }
    return true;
}



function validatePhoneNumber() {
    var phoneNumber = document.getElementById('<%= TextPHONE.ClientID %>').value.trim();
    if (phoneNumber.length !== 10 || phoneNumber.charAt(0) === '0' || isNaN(phoneNumber)) {
        document.getElementById('<%= TextPHONE.ClientID %>').setCustomValidity('Please enter a valid 10-digit phone number not starting with \'0\'.');
            } else {
                document.getElementById('<%= TextPHONE.ClientID %>').setCustomValidity('');
            }
        }


        function blockNumbers(event) {
            var charCode = (event.which) ? event.which : event.keyCode;
            if (charCode === 32) {
                return true;
            }
            if (charCode >= 48 && charCode <= 57) {
                return false;
            }
            return true;
        }

    </script>


</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <style>
        .header-center {
            text-align: center !important;
        }

        .large-header {
            font-size: 13px;
        }

        .bold-header {
            font-weight: bold;
        }

        .backbut {
            background-color: #ffe066;
            border: none;
            color: white;
            padding: 4px 8px;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            font-size: 12px;
            margin: 2px 1px;
            transition-duration: 0.4s;
            cursor: pointer;
            border-radius: 7px;
            width: 21%;
            text-align: center;
        }

        .backbut1 {
            background-color: white;
            color: black;
            border: 2px solid #0000e6;
        }

            .backbut1:hover {
                background-color: #000066;
                color: white;
            }

        .alert {
            display: block;
            padding: 10px;
            margin-bottom: 20px;
            border: 1px solid transparent;
            border-radius: 4px;
        }

        .alert-success {
            color: #3c763d;
            background-color: #dff0d8;
            border-color: #d6e9c6;
        }

          .button {
            background-color: #ffe066;
            border: none;
            color: white;
            padding: 4px 8px;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            font-size: 12px;
            margin: 2px 1px;
            transition-duration: 0.4s;
            cursor: pointer;
           
        }
          
        .button1 {
            background-color: white;
            color: black;
            border: 2px solid #009900;
        }

            .button1:hover {
                background-color: #009900;
                color: white;
            }

              .button2 {
            background-color: white;
            color: black;
            border: 2px solid #cc0000;
        }

            .button2:hover {
                background-color: #cc0000;
                color: white;
            }

         
     .center-align {
            text-align: center;
        }
    </style>

    <asp:ScriptManager ID="ScriptManager1" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div id="content-wrapper" class="d-flex flex-column">
                <div id="content">
                    <div class="container-fluid">
                        <div class="d-sm-flex align-items-center justify-content-between mb-2">
                            <h5 class="h5 mb-0 text-gray-800">CRUD OPERATIONS</h5>
                        </div>
                        <asp:Label ID="lblMessage" runat="server" CssClass="alert alert-success" Visible="false"></asp:Label>


                        <div class="container-fluid">
                            <asp:TextBox ID="HiddenFieldEditMode" runat="server" ClientIDMode="Static" Style="display: none;"></asp:TextBox>

                            <div id="table_view" class="card shadow mb-2">
                                <div id="drop_down" runat="server" class="row" style="padding-top: 10px;">
                                    <div class="col-md-6 " style="padding-left: 278px;">
                                        <label class="form-label" style="font-weight: bolder; color: brown;">SELECT TYPE :-</label>
                                        <asp:DropDownList ID="ddlOptions" runat="server" CssClass="form-control" AutoPostBack="true"
                                            OnSelectedIndexChanged="ddlOptions_SelectedIndexChanged">
                                            <asp:ListItem Text="All Data" Value="1" />
                                            <asp:ListItem Text="Create New Data" Value="2" />
                                        </asp:DropDownList>
                                    </div>
                                </div>
                                <br />

                                <div class="card-body">
                                    <asp:GridView ID="Gdv_PODPndApprvl" runat="server"
                                        AutoGenerateColumns="false" AllowPaging="true" AllowSorting="true"
                                        OnSorting="OnSorting" OnPageIndexChanging="OnPageIndexChanging" PageSize="10"
                                        CssClass="table table-striped table-bordered" OnRowCommand="Gdv_PODPndApprvl_RowCommand"
                                        DataKeyNames="EMPLOYEE_ID">
                                        <Columns>
                                            <asp:TemplateField ItemStyle-Width="150px" HeaderText="EMPLOYEE ID" SortExpression="EMPLOYEE_ID" Visible="false">
                                                <ItemTemplate>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:BoundField DataField="EMPLOYEE_NAME" HeaderText="EMPLOYEE NAME" SortExpression="EMPLOYEE_NAME" HeaderStyle-CssClass="header-center large-header bold-header" ItemStyle-HorizontalAlign="Center" ItemStyle-Font-Size="13px" />
                                            <asp:BoundField DataField="DESIGNATION" HeaderText="DESIGNATION" SortExpression="DESIGNATION" HeaderStyle-CssClass="header-center large-header bold-header" ItemStyle-HorizontalAlign="Center" ItemStyle-Font-Size="13px" />
                                            <asp:BoundField DataField="POST" HeaderText="POST" SortExpression="POST" HeaderStyle-CssClass="header-center large-header bold-header" ItemStyle-HorizontalAlign="Center" ItemStyle-Font-Size="13px" />
                                            <asp:BoundField DataField="PLACE" HeaderText="PLACE" SortExpression="PLACE" HeaderStyle-CssClass="header-center large-header bold-header" ItemStyle-HorizontalAlign="Center" ItemStyle-Font-Size="13px" />
                                            <asp:BoundField DataField="PHONE" HeaderText="PHONE" SortExpression="PHONE" HeaderStyle-CssClass="header-center large-header bold-header" ItemStyle-HorizontalAlign="Center" ItemStyle-Font-Size="13px" />
                                            <asp:TemplateField HeaderText="EDIT" HeaderStyle-CssClass="header-center large-header bold-header">
                                                <ItemTemplate >
                                                    <div class="center-align">
                                                    <asp:Button ID="edit_but" runat="server" CommandName="EDIT" Text="EDIT"  CssClass="button button1"
                                                        data-employeeId='<%# Eval("EMPLOYEE_ID") %>'
                                                        data-employeeName='<%# Eval("EMPLOYEE_NAME") %>'
                                                        data-designation='<%# Eval("DESIGNATION") %>'
                                                        data-post='<%# Eval("POST") %>'
                                                        data-place='<%# Eval("PLACE") %>'
                                                        data-phone='<%# Eval("PHONE") %>'
                                                        OnClientClick='<%# "handleEditButtonClick(\"" + Eval("EMPLOYEE_ID") + "\", \"" + Eval("EMPLOYEE_NAME") + "\", \"" + Eval("DESIGNATION") + "\", \"" + Eval("POST") + "\", \"" + Eval("PLACE") + "\", \"" + Eval("PHONE") + "\"); return false;" %>' />
                                               </div>
                                                         </ItemTemplate>
                                            </asp:TemplateField >

                                             <asp:TemplateField HeaderText="DELETE" HeaderStyle-CssClass="header-center large-header bold-header">
                    <ItemStyle CssClass="centered-cell" />
                                                  <ItemTemplate>
                        <div class="center-align">
                        <asp:Button ID="delete_but" runat="server" CommandName="DELETE" Text="DELETE"
                           CssClass="button button2"
                            OnClientClick='<%# "handleDeleteButtonClick(\"" + Eval("EMPLOYEE_ID") + "\", \"" + Eval("EMPLOYEE_NAME") + "\", \"" + Eval("DESIGNATION") + "\", \"" + Eval("POST") + "\", \"" + Eval("PLACE") + "\", \"" + Eval("PHONE") + "\")" %>'
                            CommandArgument='<%# Container.DataItemIndex %>' />
                    </div>
                            </ItemTemplate>
                </asp:TemplateField>
                                        </Columns>
                                    </asp:GridView>



                                    <div id="full_div" runat="server" style="display: none;">

                                        <div class="row" id="div_emp_det" style="padding-top: 10px;">
                                            <div class="col-xs-6 col-sm-6">
                                                <label class="form-label">EMPLOYEE ID <span style="color: red;">*</span></label>
                                                <asp:TextBox ID="Txtemp_id" class="form-control" runat="server" BackColor="White" AutoComplete="off" onkeypress="return blockSpecialCharacters(event);" disabled="disabled"></asp:TextBox>
                                            </div>


                                            <div class="col-xs-6 col-sm-6">
                                                <label class="form-label">EMPLOYEE NAME <span style="color: red;">*</span></label>
                                                <asp:TextBox ID="txtemp_name" CssClass="form-control" runat="server" MaxLength="12" AutoComplete="off" onkeypress="return blockNumbers(event);" onpaste="return false;"></asp:TextBox>
                                                <asp:Label ID="LblAmntwrds" CssClass="lblCSS" runat="server" Style="color: orangered; flex-align: center" Font-Bold="true"></asp:Label>
                                            </div>



                                        </div>



                                        <div class="row" id="div_des" style="padding-top: 10px;">
                                            <div class="col-xs-6 col-sm-6">
                                                <label class="form-label">DESIGNATION <span style="color: red;">*</span></label>
                                                <asp:TextBox ID="TextDESIGNATION" class="form-control" runat="server" BackColor="White" onkeypress="return blockNumbers(event);" AutoComplete="off"></asp:TextBox>
                                            </div>


                                            <divy class="col-xs-6 col-sm-6">
                                                <label class="form-label">POST <span style="color: red;">*</span></label>
                                                <asp:TextBox ID="TextPOST" class="form-control" runat="server" onkeypress="return blockNumbers(event);" MaxLength="12" AutoComplete="off" oninput="return maxLengthCheck(this);"></asp:TextBox>
                                                <asp:Label ID="Label1" CssClass="lblCSS" runat="server" Style="color: orangered; flex-align: center" Font-Bold="true"></asp:Label>

                                            </divy>


                                        </div>


                                        <div class="row" id="div_ph" style="padding-top: 10px;">
                                            <div class="col-xs-6 col-sm-6">
                                                <label class="form-label">PLACE  <span style="color: red;">*</span></label>
                                                <asp:TextBox ID="PLACE_num" class="form-control" runat="server" BackColor="White" AutoComplete="off" onkeypress="return blockSpecialCharacters(event);"></asp:TextBox>
                                            </div>

                                            <div class="col-xs-6 col-sm-6">
                                                <label class="form-label">PHONE <span style="color: red;">*</span></label>
                                                <asp:TextBox ID="TextPHONE" CssClass="form-control" runat="server" BackColor="White" AutoComplete="off" onkeypress="return isNumberKey(event);" onkeyup="validatePhoneNumber();" MaxLength="10"></asp:TextBox>
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="TextPHONE" Display="Dynamic" ErrorMessage="Please enter a valid 10-digit phone number starting with '0'." ValidationGroup="validatePhone">*</asp:RequiredFieldValidator>
                                            </div>



                                        </div>

                                        <div class="row" id="button_div" style="padding-top: 35px; padding-right: 37px;">



                                            <div class="col-xs-6 col-sm-6" style="text-align: end">
                                                <asp:Button ID="save_but" runat="server" OnClientClick="  return  validateFields();" OnClick="save_but_Click"
                                                    class="btn btn-raised btn-primary waves-effect" Style="width: 125px;" Text="UPDATE" />
                                            </div>

                                            <div class="col-xs-6 col-sm-6" style="">
                                                <asp:Button ID="cancelbut" runat="server" OnClientClick="  return  validateFields();"
                                                    class="btn btn-raised btn-primary waves-effect" Style="width: 125px;" Text="BACK" OnClick="RedirectToBackbutton_Click" />
                                            </div>

                                        </div>


                                        <div class="row" id="button_divES" style="padding-right: 37px;">

                                            <div class="col-xs-6 col-sm-6" style="text-align: end; padding-left: 643px;">
                                                <asp:Button ID="ADD" runat="server" OnClientClick="return validateFields();" OnClick="add_but_Click"
                                                    class="btn btn-raised btn-primary waves-effect" Style="width: 125px;" Text="ADD" />
                                            </div>
                                            <div class="col-xs-6 col-sm-6" style="text-align: end;">
                                                <asp:Button ID="CANCEL_BUTT" runat="server" OnClick="RedirectToBackbutton_Click"
                                                    class="btn btn-raised btn-primary waves-effect" Style="width: 125px;" Text="BACK" />
                                            </div>



                                        </div>

                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </ContentTemplate>
        <Triggers>
            <asp:PostBackTrigger ControlID="ADD" />


        </Triggers>
    </asp:UpdatePanel>
</asp:Content>
