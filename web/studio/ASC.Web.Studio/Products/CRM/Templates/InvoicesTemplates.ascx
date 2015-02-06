﻿<%@ Control Language="C#" AutoEventWireup="false" EnableViewState="false" %>
<%@ Assembly Name="ASC.Web.CRM" %>
<%@ Assembly Name="ASC.Web.Core" %>
<%@ Import Namespace="ASC.Web.CRM.Classes" %>
<%@ Import Namespace="ASC.Web.CRM.Configuration" %>
<%@ Import Namespace="ASC.Web.Core.Mobile" %>
<%@ Import Namespace="ASC.Web.Core.Utility.Skins" %>
<%@ Import Namespace="ASC.Web.CRM.Resources" %>

<%--Invoice List--%>
<script id="invoicesListBaseTmpl" type="text/x-jquery-tmpl">
    <div id="invoiceFilterContainer">
        <div id="invoiceAdvansedFilter"></div>
    </div>

    <div id="invoiceList" style="display:none; min-height: 400px;">
        <ul id="invoiceHeaderMenu" class="clearFix contentMenu contentMenuDisplayAll">
            <li class="menuAction menuActionSelectAll menuActionSelectLonely">
                <div class="menuActionSelect">
                    <input type="checkbox" id="mainSelectAllInvoices" title="<%=CRMCommonResource.SelectAll%>" onclick="ASC.CRM.ListInvoiceView.selectAll(this);" />
                </div>
            </li>
            <li class="menuAction menuActionChangeStatus" title="<%= CRMInvoiceResource.ChangeInvoiceStatus %>">
                <span><%= CRMInvoiceResource.ChangeInvoiceStatus %></span>
                <div class="down_arrow"></div>
            </li>
            <li class="menuAction menuActionDelete" title="<%= CRMCommonResource.Delete %>">
                <span><%= CRMCommonResource.Delete %></span>
            </li>

            <li class="menu-action-simple-pagenav">
            </li>
            <li class="menu-action-checked-count">
                <span></span>
                <a class="linkDescribe baseLinkAction" style="margin-left:10px;" onclick="ASC.CRM.ListInvoiceView.deselectAll();">
                    <%= CRMCommonResource.DeselectAll%>
                </a>
            </li>
            <li class="menu-action-on-top">
                <a class="on-top-link" onclick="javascript:window.scrollTo(0, 0);">
                    <%= CRMCommonResource.OnTop%>
                </a>
            </li>
        </ul>
        <div class="header-menu-spacer">&nbsp;</div>

        <div id="changeStatusDialog" class="studio-action-panel changeStatusDialog">
            <ul class="dropdown-content mobile-overflow"></ul>
        </div>

        <table id="invoiceTable" class="tableBase" cellpadding="4" cellspacing="0">
            <colgroup>
                <col style="width: 22px;"/>
                <col style="width: 1%;"/>
                <col/>
                <col style="width: 1%;"/>
                <col style="width: 1%;"/>
                <col style="width: 1%;"/>
                <col style="width: 40px;"/>
            </colgroup>
            <tbody>
            </tbody>
        </table>

        <table id="tableForInvoiceNavigation" class="crm-navigationPanel" cellpadding="4" cellspacing="0" border="0">
            <tbody>
            <tr>
                <td>
                    <div id="divForInvoicePager">
                    </div>
                </td>
                <td style="text-align:right;">
                    <span class="gray-text"><%= CRMInvoiceResource.TotalInvoices %>:</span>
                    <span class="gray-text" id="totalInvoicesOnPage"></span>

                    <span class="gray-text"><%= CRMCommonResource.ShowOnPage %>:&nbsp;</span>
                    <select class="top-align">
                        <option value="25">25</option>
                        <option value="50">50</option>
                        <option value="75">75</option>
                        <option value="100">100</option>
                    </select>
                </td>
            </tr>
            </tbody>
        </table>
    </div>

    <div id="invoiceActionMenu" class="studio-action-panel">
        <ul class="dropdown-content">
            <li><a class="showProfileLink dropdown-item"><%= CRMInvoiceResource.ShowInvoiceProfile %></a></li>
            <% if (Global.CanDownloadInvoices) { %>
            <li><a class="downloadLink dropdown-item"><%= CRMInvoiceResource.Download %></a></li>
            <% } %>
            <% if (MobileDetector.IsMobile) { %>
            <li><a class="printLink dropdown-item"><%= CRMInvoiceResource.Print %></a></li>
            <% } %>
            <% if (Global.CanDownloadInvoices) { %>
            <li><a class="sendLink dropdown-item"><%= CRMInvoiceResource.SendByEmail %></a></li>
            <% } %>
            <li><a class="duplicateInvoiceLink dropdown-item"><%= CRMInvoiceResource.DuplicateInvoice %></a></li>
            <li><a class="editInvoiceLink dropdown-item"><%= CRMInvoiceResource.EditInvoice %></a></li>
            <li><a class="deleteInvoiceLink dropdown-item"><%= CRMInvoiceResource.DeleteThisInvoice %></a></li>
        </ul>
    </div>

    <div id="hiddenBlockForInvoiceContactSelector" style="display:none;">
        <span id="invoiceContactSelectorForFilter" class="custom-value">
            <span class="inner-text">
                <span class="value"><%= CRMCommonResource.Select %></span>
            </span>
        </span>
    </div>

</script>


<script id="invoiceListTmpl" type="text/x-jquery-tmpl">
    <tbody>
        {{tmpl(invoices) "invoiceTmpl"}}
    </tbody>
</script>

<script id="invoiceTmpl" type="text/x-jquery-tmpl">
    <tr id="invoice_${id}" class="with-entity-menu {{if isChecked == true}}selected{{/if}}">
        {{if isSimpleView != true}}
        <td class="borderBase" style="padding: 0 0 0 6px;">
            <input type="checkbox" id="checkInvoice_${id}" onclick="ASC.CRM.ListInvoiceView.selectItem(this);" {{if isChecked == true}}checked="checked"{{/if}} />
            <div id="loaderImg_${id}" class="loader-middle baseList_loaderImg"></div>
        </td>
        {{/if}} 
        <td class="borderBase">
            <a class="linkHeaderMedium invoiceNumber {{if status.id == 3}}gray-text{{/if}}{{if debtor == true}}red-text{{/if}}" href="invoices.aspx?id=${id}" title="${number}">
                ${number}
            </a>
            <div class="{{if status.id == 3}}gray-text{{/if}}">
                ${issueDateString}
            </div>
        </td>

        {{if isSimpleView != true}}
        <td class="borderBase invoiceContact">
            {{if contact != null}}
                <div>
                {{if contact.isCompany == true}}
                    <a href="default.aspx?id=${contact.id}" data-id="${contact.id}"
                            id="invoice_${id}_company_${contact.id}" class="linkMedium crm-companyInfoCardLink {{if status.id == 3}}gray-text{{/if}}">
                        ${contact.displayName}
                    </a>
                {{else}}
                    <a href="default.aspx?id=${contact.id}&type=people" data-id="${contact.id}"
                            id="invoice_${id}_person_${contact.id}" class="linkMedium crm-peopleInfoCardLink {{if status.id == 3}}gray-text{{/if}}">
                        ${contact.displayName}
                    </a>
                {{/if}}
                </div>
            {{/if}}
        </td>
        {{/if}}

        <td class="borderBase invoiceDueDate">
            <div class="{{if status.id == 3}}gray-text{{/if}}">
                ${dueDateString}
            </div>
        </td>
        <td class="borderBase invoiceStatus">
            <div class="{{if status.id == 3}}gray-text{{/if}}{{if debtor == true}}red-text{{/if}}" data-status-id="${status.id}">
                ${status.title.toLowerCase()}
            </div>
        </td>
        <td class="borderBase invoiceSum">
            <div {{if status.id == 3}}class="gray-text"{{/if}}>
               {{html displaySum}}
            </div>
        </td>

        <td class="borderBase" style="padding:5px;">
            <div id="invoiceMenu_${id}" class="entity-menu" title="<%= CRMCommonResource.Actions %>"></div>
        </td>
    </tr>
</script>



<%--Invoice Action--%>
<script id="invoiceLineTableTmpl" type="text/x-jquery-tmpl">
    <div class="tbl">
        <div class="tbl-row tbl-header-row clearFix">
            <div class="tbl-cell sorter">&nbsp;</div>
            <div class="tbl-cell item"><%= CRMInvoiceResource.ItemCol %>:</div>
            <div class="tbl-cell quantity"><%= CRMInvoiceResource.QuantityCol %>:</div>
            <div class="tbl-cell price"><%= CRMInvoiceResource.PriceCol %>:</div>
            <div class="tbl-cell discount"><%= CRMInvoiceResource.DiscountCol %>:</div>
            <div class="tbl-cell tax1"><%= CRMInvoiceResource.TaxCol %>:</div>
            <div class="tbl-cell tax2"><%= CRMInvoiceResource.TaxCol %>:</div>
            <div class="tbl-cell amount"><%= CRMInvoiceResource.AmountCol %>:</div>
            <div class="tbl-cell action">&nbsp;</div>
        </div>
        <div class="tbl-body">
            {{tmpl(invoiceLines) "invoiceLineTmpl"}}
        </div>
        <div class="tbl-row tbl-add-row clearFix">
            <a class="link plus dotline add-line"><%= CRMInvoiceResource.AddLineButton %></a>
        </div>
        <div class="tbl-row tbl-subtotal-row clearFix">
            <div class="tbl-cell total-label"><%= CRMInvoiceResource.Subtotal %>:</div>
            <div class="tbl-cell total-value subtotal">${(subtotal - discountValue).toFixed(2)}</div>
        </div>
        <div class="tbl-taxes">
            {{tmpl(taxLines) "invoiceTaxLineTmpl"}}
        </div>
        <div class="tbl-row tbl-total-row clearFix">
            <div class="tbl-cell total-label"><%= CRMInvoiceResource.Total %>&nbsp;(<span class="currency">${currency}</span>):</div>
            <div class="tbl-cell total-value total">${total.toFixed(2)}</div>
        </div>
    </div>
    <div id="selectItemDialog" class="studio-action-panel selector">
        {{if isAdmin == true}}
        <div class="left-side">
            <div class="headerPanelSmall-splitter">
                <div class="header-base-small"><%= CRMInvoiceResource.FormInvoiceItemName %></div>
                <input type="text" class="textEdit" id="newItemName">
            </div>
            <div class="headerPanelSmall-splitter">
                <div class="header-base-small"><%= CRMInvoiceResource.FormInvoiceItemPrice %></div>
                <input type="text" class="textEdit" id="newItemPrice">
            </div>
            <div class="button-container">
                <a class="button gray disable create-btn"><%= CRMCommonResource.Create %></a>
                <a class="button gray cancel-btn"><%= CRMCommonResource.Cancel %></a>
            </div>
        </div>
        {{/if}}
        <div class="right-side">
            <div class="headerPanelSmall-splitter custom-input">
                <input type="text"/>
                <div class="icon serch"></div>
            </div>
            {{if isAdmin == true}}
            <div class="headerPanelSmall-splitter">
                <a class="link plus dotline add-new-btn"><%= CRMInvoiceResource.CreateNewInvoiceItem %></a>               
            </div>
            {{/if}}
            <ul class="custom-list {{if isAdmin == false}}large{{/if}}"></ul>
        </div>
    </div>
    <div id="selectTaxDialog" class="studio-action-panel selector">
        {{if isAdmin == true}}
        <div class="left-side">
            <div class="headerPanelSmall-splitter">
                <div class="header-base-small"><%= CRMInvoiceResource.InvoiceTaxName %></div>
                <input type="text" class="textEdit" id="newTaxName">
            </div>
            <div class="headerPanelSmall-splitter">
                <div class="header-base-small"><%= CRMInvoiceResource.InvoiceTaxRate %></div>
                <input type="text" class="textEdit small" id="newTaxRate" maxlength="4"> %
            </div>
            <div class="button-container">
                <a class="button gray disable create-btn"><%= CRMCommonResource.Create %></a>
                <a class="button gray cancel-btn"><%= CRMCommonResource.Cancel %></a>
                <div class="createTaxError" title="<%= CRMInvoiceResource.InvoiceTaxAlreadyRegisteredError %>"><%= CRMInvoiceResource.InvoiceTaxAlreadyRegisteredError %></div>
            </div>
        </div>
        {{/if}}
        <div class="right-side">
            <div class="headerPanelSmall-splitter">
                <a class="link dotline set-default-btn {{if isAdmin == true}}right{{/if}}"><%= CRMInvoiceResource.SetEmpty %></a>
                {{if isAdmin == true}}
                <a class="link plus dotline add-new-btn"><%= CRMInvoiceResource.CreateNewInvoiceTax %></a>
                {{/if}}
            </div>
            <ul class="custom-list"></ul>
        </div>
    </div>
</script>

<script id="invoiceLineTmpl" type="text/x-jquery-tmpl">
    <div id="invoiceLine_${id}" class="tbl-row tbl-body-row">
        <div class="clearFix">
            <div class="tbl-cell item">
                <div class="custom-input">
                    <input type="text" readonly="readonly" value="${invoiceItem ? invoiceItem.title : ''}" placeholder="<%= CRMInvoiceResource.EmptyProductText %>"/>
                    <div class="icon drop-down"></div>
                    <input type="hidden" value="${invoiceItem ? invoiceItem.id : 0}" name="iLineItem_${id}_"/>
                </div>
            </div>
            <div class="tbl-cell quantity">
                <input type="text" value="${quantity}" class="textEdit" name="iLineQuantity_${id}_"/>
            </div>
            <div class="tbl-cell price">
                <input type="text" value="${price.toFixed(2)}" class="textEdit" name="iLinePrice_${id}_"/>
            </div>
            <div class="tbl-cell discount">
                <input type="text" value="${discount}" class="textEdit" name="iLineDiscount_${id}_"/>(%)
            </div>
            <div class="tbl-cell tax1">
                <div class="custom-input">
                    <input type="text" readonly="readonly" value="${invoiceTax1 ? invoiceTax1.name : ''}" placeholder="<%= CRMInvoiceResource.EmptyTaxText %>"/>
                    <div class="icon drop-down"></div>
                    <input type="hidden" value="${invoiceTax1 ? invoiceTax1.id : 0}" name="iLineTax1_${id}_"/>
                </div>
            </div>
            <div class="tbl-cell tax2">
                <div class="custom-input">
                    <input type="text" readonly="readonly" value="${invoiceTax2 ? invoiceTax2.name : ''}" placeholder="<%= CRMInvoiceResource.EmptyTaxText %>"/>
                    <div class="icon drop-down"></div>
                    <input type="hidden" value="${invoiceTax2 ? invoiceTax2.id : 0}" name="iLineTax2_${id}_"/>
                </div>
            </div>
            <div class="tbl-cell amount">
                ${(subtotal - discountValue).toFixed(2)}
            </div>
        </div>
        <div class="description">
            <textarea name="iLineDescription_${id}_" placeholder="<%= CRMInvoiceResource.DescriptionCol %>">${description}</textarea>
        </div>
        <div class="sorter">
            <a class="crm-moveLink"></a>
        </div>
        <div class="action">
            <a class="crm-removeLink"></a>
        </div>
    </div>
</script>

<script id="invoiceTaxLineTmpl" type="text/x-jquery-tmpl">
    <div class="tbl-row tbl-subtotal-row clearFix">
        <div class="tbl-cell total-label"><span class="taxLineName" title="${name}">${name}</span>&nbsp;<span class="taxLineRate">(${rate}%):</span></div>
        <div class="tbl-cell total-value tax-value">${value.toFixed(2)}</div>
    </div>
</script>



<%--Invoice Details--%>
<script id="invoiceDetailsTmpl" type="text/x-jquery-tmpl">
    <div class="invoice-container">
        <div class="invoice-data">
            <table cellpadding="0" cellspacing="0" class="tbl-seller">
                <tbody>
                    <tr>
                        <td class="width-50">
                            {{if Seller != null}}
                            {{html jq.htmlEncodeLight(Seller.Item2).replace(/&#10;/g, "<br/>").replace(/  /g, " &nbsp;") }}
                            {{/if}}
                        </td>
                        <td class="width-50 text-right">
                            {{if LogoBase64}}
                            <img class="logo" src="${LogoSrcFormat.format(LogoBase64)}"/>
                            {{/if}}
                        </td>
                    </tr>
                </tbody>
            </table>
            <br />
            <br />
            <table cellpadding="0" cellspacing="0" class="tbl-invoice">
                <tbody>
                    <tr>
                        <td class="width-50">
                            {{if Number != null}}
                            <div class="background-gray invoice-number">
                                <span class="font-22 font-gray">${Number.Item1}</span>
                                <span class="font-16 font-gray">№</span>
                                <span class="font-16">${Number.Item2}</span>
                            </div>
                            {{/if}}
                        </td>
                        <td class="width-50">
                            <table cellpadding="0" cellspacing="0">
                                <tbody>
                                    {{each(i, info) Invoice}}
                                    <tr>
                                        <td class="width-25 font-bold text-right">${info.Item1}:</td>
                                        <td class="width-5">&nbsp;</td>
                                        <td class="width-20">${info.Item2}</td>
                                    </tr>
                                    {{/each}}
                                </tbody>
                            </table>
                        </td>
                    </tr>
                </tbody>
            </table>
            <br />
            <br />
            <table cellpadding="0" cellspacing="0" class="tbl-customer">
                <tbody>
                    <tr>
                        <td class="width-50">
                            {{if Customer != null}}
                            <div class="font-bold">${Customer.Item1}:</div>
                            {{html jq.htmlEncodeLight(Customer.Item2).replace(/&#10;/g, "<br/>").replace(/  /g, " &nbsp;") }}
                            {{/if}}
                        </td>
                        <td class="width-50"></td>
                    </tr>
                </tbody>
            </table>
            <br />
            <br />
            <table class="tbl-items" cellpadding="0" cellspacing="0">
                <tbody>
                    <tr class="background-gray">
                        {{each(i, info) TableHeaderRow}}
                            {{if i == 0}}
                            <td class="font-gray width-40">${info}:</td>
                            {{else}}
                            <td class="font-gray width-10 {{if i == TableHeaderRow.length - 1}} text-right{{/if}}">${info}:</td>
                            {{/if}}
                        {{/each}}
                    </tr>
                    {{each(i, row) TableBodyRows}}
                        <tr>
                        {{each(j, info) row}}
                            {{if j == 0}}
                            <td class="border-bottom-gray width-40 {{if j == row.length - 1}} text-right{{/if}}">
                                {{html jq.htmlEncodeLight(info).replace(/&#10;/g, "<br/>").replace(/  /g, " &nbsp;") }}
                            </td>
                            {{else}}
                            <td class="border-bottom-gray width-10 {{if j == row.length - 1}} text-right{{/if}}">
                                {{html jq.htmlEncodeLight(info).replace(/&#10;/g, "<br/>").replace(/  /g, " &nbsp;") }}
                            </td>
                            {{/if}}
                        {{/each}}
                        </tr>
                    {{/each}}
                    {{each(i, info) TableFooterRows}}
                    <tr>
                        <td colspan="2" class="width-50"></td>
                        <td colspan="3" class="width-30">${info.Item1}:</td>
                        <td colspan="2" class="width-20 text-right">${info.Item2}</td>
                    </tr>
                    {{/each}}
                    {{if TableTotalRow != null}}
                    <tr>
                        <td colspan="2" class="width-50"></td>
                        <td colspan="3" class="background-gray width-30 font-bold">${TableTotalRow.Item1}:</td>
                        <td colspan="2" class="background-gray width-20 font-bold text-right">${TableTotalRow.Item2}</td>
                    </tr>
                    {{/if}}
                </tbody>
            </table>
            <br />
            <br />
            <table cellpadding="0" cellspacing="0" class="tbl-terms">
                <tbody>    
                    <tr>
                        <td><span class="font-bold">${Terms.Item1}:</span>&nbsp;{{html jq.htmlEncodeLight(Terms.Item2).replace(/&#10;/g, "<br/>").replace(/  /g, " &nbsp;") }}</td>
                    </tr>
                </tbody>
            </table>
            <br />
            {{if Notes != null}}
            <table cellpadding="0" cellspacing="0" class="tbl-notes">
                <tbody>
                    <tr>
                        <td><span class="font-bold">${Notes.Item1}:</span>&nbsp;{{html jq.htmlEncodeLight(Notes.Item2).replace(/&#10;/g, "<br/>").replace(/  /g, " &nbsp;") }}</td>
                    </tr>
                </tbody>
            </table>
            <br />
            {{/if}}
            <table cellpadding="0" cellspacing="0" class="tbl-consignee">
                <tbody>
                    <tr>
                        <td class="width-50">
                            {{if Consignee != null}}
                            <div class="font-bold">${Consignee.Item1}:</div>
                            {{html jq.htmlEncodeLight(Consignee.Item2).replace(/&#10;/g, "<br/>").replace(/  /g, " &nbsp;") }}
                            {{/if}}
                        </td>
                        <td class="width-50"></td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</script>

<%--Invoice Details Styles--%>
<script id="invoiceDetailsStylesTmpl" type="text/x-jquery-tmpl">
    <style>
        @font-face {
          font-family: 'Open Sans';
          font-style: normal;
          font-weight: normal;
          src: local('Open Sans'), local('OpenSans'), url(https://themes.googleusercontent.com/static/fonts/opensans/v7/uYKcPVoh6c5R0NpdEY5A-Q.woff) format('woff');
        }
        @media screen {
            body {padding: 0; margin: 2.645833mm;}
            .invoice-container {
                width: 168mm;
                min-height: 259mm;
                padding: 19mm 14mm 19mm 28mm;
                border: 1px solid #D1D1D1;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.5);
                -moz-box-shadow: 0 2px 4px rgba(0, 0, 0, 0.5);
                -webkit-box-shadow: 0 2px 4px rgba(0, 0, 0, 0.5);
            }
        }
        @media print {
            body {padding: 0; margin: 0;}
        }
        @page  
        { 
            size: auto;
            margin: 19mm 14mm 19mm 28mm;
        }
        .invoice-data {
            background-color: #FFFFFF;
            color: #333333;
            font-family: 'Open Sans',sans-serif;
            font-size: 10pt;
        }
        .invoice-data table {
            border-collapse: collapse;
            color: #333333;
            font-family: 'Open Sans',sans-serif;
            font-size: 10pt;
            width: 100%;
        }
        .invoice-data table td {
            vertical-align: top;
            word-wrap: break-word;
        }
        .invoice-data table .width-50 {
            max-width: 84mm;
            width: 84mm;
        }
        .invoice-data table .width-40 {
            max-width: 65.0833mm;
            width: 65.0833mm;
        }
        .invoice-data table .width-30 {
            max-width: 48.2833mm;
            width: 48.2833mm;
        }
        .invoice-data table .width-25 {
            max-width: 39.8833mm;
            width: 39.8833mm;
        }
        .invoice-data table .width-20 {
            max-width: 31.4833mm;
            width: 31.4833mm;
        }
        .invoice-data table .width-10 {
            max-width: 14.6833mm;
            width: 14.6833mm;
        }
        .invoice-data table .width-5 {
            max-width: 6.2833mm;
            width: 6.2833mm;
        }
        .invoice-data table .text-right {
            text-align: right;
        }
        .invoice-data table .border-bottom-gray {
            border-bottom: 0.264583mm solid #EEEEEE;
        }
        .invoice-data table .background-gray {
            background-color: #EEEEEE;
        }
        .invoice-data table .font-gray {
            color: #999999;
        }
        .invoice-data table .font-22 {
            font-size: 22pt;
        }
        .invoice-data table .font-16 {
            font-size: 16pt;
        }
        .invoice-data table .font-bold {
            font-weight: bold;
        }
        .invoice-data table .logo {
            max-height: 39.6875mm;
            max-width: 52.9167mm;
        }
        .invoice-data table .invoice-number {
            padding: 0 1.05833mm;
        }
        .invoice-data table.tbl-items {
            font-size: 8pt;
        }
        .invoice-data table.tbl-items td {
            padding: 1.9mm 1.05833mm;
        }
    </style>
</script>



<%--Invoice Number Format Dialog--%>
<script id="numberFormatDialogTmpl" type="text/x-jquery-tmpl">
    <div class="headerPanelSmall-splitter"><%= CRMInvoiceResource.ChangeFormatInfo%></div>
    <div class="headerPanelSmall-splitter">
        <input type="checkbox" id="autogenCbx">
        <label for="autogenCbx"><%= CRMInvoiceResource.AutomaticallyGenerated%> </label>
    </div>
    <div class="clearFix">
        <div class="number-prefix">
            <div class="header-base-small headerPanelSmall"><%= CRMInvoiceResource.Prefix%>:</div>
            <input type="text" id="prefixInpt" class="textEdit">
        </div>
        <div class="number-number requiredField">
            <div class="header-base-small headerPanelSmall"><%= CRMInvoiceResource.StartNumber%>:</div>
            <input type="text" id="numberInpt" class="textEdit">
        </div>
    </div>
    <div class="error-popup"></div>
    <div class="big-button-container">
        <a class="button blue middle"><%= CRMCommonResource.Save%></a>
        <span class="splitter-buttons"></span>
        <a class="button gray middle" onclick="PopupKeyUpActionProvider.EnableEsc = true; jq.unblockUI();">
            <%= CRMCommonResource.Cancel%>
        </a>
    </div>
</script>

<%--Invoice Default Terms Dialog--%>
<script id="defaultTermsDialogTmpl" type="text/x-jquery-tmpl">
    <div class="headerPanelSmall-splitter"><%= CRMInvoiceResource.DefaultTermsInfo%></div>
    <div class="header-base-small headerPanelSmall"><%= CRMInvoiceResource.Terms%>:</div>
    <textarea id="defaultTerms"></textarea>
    <div class="error-popup"></div>
    <div class="big-button-container">
        <a class="button blue middle"><%= CRMCommonResource.Save%></a>
        <span class="splitter-buttons"></span>
        <a class="button gray middle" onclick="PopupKeyUpActionProvider.EnableEsc = true; jq.unblockUI();">
            <%= CRMCommonResource.Cancel%>
        </a>
    </div>
</script>

<%--Invoice Delete Dialog--%>
<script id="deleteDialogTmpl" type="text/x-jquery-tmpl">
    <div class="header-base-small headerPanelSmall"></div>
    <div><%= CRMJSResource.DeleteConfirmNote%></div>
    <div class="error-popup"></div>
    <div class="big-button-container">
        <a class="button blue middle"><%= CRMCommonResource.OK%></a>
        <span class="splitter-buttons"></span>
        <a class="button gray middle" onclick="PopupKeyUpActionProvider.EnableEsc = true; jq.unblockUI();">
            <%= CRMCommonResource.Cancel%>
        </a>
    </div>
</script>