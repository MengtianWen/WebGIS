    <%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MainPage.aspx.cs" Inherits="WebGISProject.DBOperation" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>

    <script src="../libs/ol.js"></script>
    <link href="../libs/ol.css" rel="stylesheet" />
    <!--  引入第三方插件库 -->
    <script src="../libs/jquery-1.11.2.min.js"></script>
    <script src="../libs/jquery-ui-1.11.4/jquery-ui.min.js"></script>
    <link href="../libs/jquery-ui-1.11.4/jquery-ui.min.css" rel="stylesheet" />


    <title> Web GIS</title>
    
    <style type="text/css">
        body,html,div,ul,li,iframe,p,img{
            border:none;padding:0;margin:0;
        }
        #mapCon {
            width: 100%;
            height: 70%;
            position: absolute;
        }
        /* 鼠标位置控件层样式设置 */
        #mouse-position {
            float: left;
            position: absolute;
            bottom: 5px;
            width: 314px;
            height: 30px;
            /*在地图容器中的层，要设置z-index的值让其显示在地图上层*/
            z-index: 2000;
            left: 0px;
        }
        /* 鼠标位置信息自定义样式设置 */
        .custom-mouse-position {
            color: rgb(0,0,0);
            font-size: 16px;
            font-family: "微软雅黑";
        }
        .auto-style1 {
            text-align: center;
        }

         #dialog-confirm{
            font-size:14px;
            font-family:"微软雅黑";
        }
        .ui-widget-header { border: 1px solid #aaaaaa; background: #cccccc  50% 50% repeat-x; color: #222222; font-weight: bold; }
        .ui-widget, .ui-widget input, .ui-widget select{font-size:14px;font-family:"微软雅黑";}
        .ui-widget .ui-widget{font-size:14px; font-family:"微软雅黑"; color: #222222;}

    </style>

    
</head>
<body >
    <form id="form1" runat="server">
        <%--查询等功能键、数据源以及数据列表--%>
        <div id="function" class="auto-style1">
            <asp:Label ID="Label1" runat="server" Text="查询条件：       "></asp:Label>
            <asp:Label ID="Label2" runat="server" Text="类型："></asp:Label>
            <asp:DropDownList ID="ddl_type" runat="server" Height="20px" Width="198px" 
                style="z-index:990" AppendDataBoundItems="True" OnLoad="ddl_type_Load">
            </asp:DropDownList>
            <asp:Label ID="Label3" runat="server" Text="名称："></asp:Label>
            <asp:TextBox ID="txt_name" runat="server" Height="20px"></asp:TextBox>
            <asp:Button ID="btn_Query" runat="server" Text="查询" style="text-align: center" OnClick="btn_Query_Click" />
            &nbsp;
            <input id="Add" type="button" value="添加要素" onclick="AddPoint()"/>
            <input id="StopAdd" type="button" value="停止绘制" onclick="CancelAdd()"/>
     
            <asp:GridView ID="gvGIS" runat="server" AutoGenerateColumns="False" DataKeyNames="ID,pnt_x,pnt_y,pnt_type,pnt_name,pnt_attribute" HorizontalAlign="Center" Width="90%" BorderStyle="None" BorderWidth="1px" DataSourceID="DBGIS" BackColor="White" BorderColor="#E7E7FF" CellPadding="3" GridLines="Horizontal" Height="10px" PageSize="5">
                <AlternatingRowStyle Wrap="True" BackColor="#F7F7F7" />
                <Columns>
                    <asp:BoundField DataField="ID" HeaderText="ID" InsertVisible="False" ReadOnly="True" SortExpression="ID" />
                    <asp:BoundField DataField="pnt_x" HeaderText="X" SortExpression="pnt_x" />
                    <asp:BoundField DataField="pnt_y" HeaderText="Y" SortExpression="pnt_y" />
                    <asp:BoundField DataField="pnt_type" HeaderText="类别" SortExpression="pnt_type" />
                    <asp:BoundField DataField="pnt_name" HeaderText="名称" SortExpression="pnt_name" />
                    <asp:BoundField DataField="pnt_attribute" HeaderText="属性" SortExpression="pnt_attribute" />
                    <asp:CommandField ShowDeleteButton="True" ShowEditButton="True" ButtonType="Button" HeaderText="操作" />
                </Columns>
                <FooterStyle BackColor="#B5C7DE" ForeColor="#4A3C8C" />
                <HeaderStyle BackColor="#4A3C8C" Font-Bold="True" ForeColor="#F7F7F7" />
                <PagerStyle BackColor="#E7E7FF" ForeColor="#4A3C8C" HorizontalAlign="Right" />
                <RowStyle HorizontalAlign="Center" BackColor="#E7E7FF" ForeColor="#4A3C8C" />
                <SelectedRowStyle BorderStyle="Groove" BackColor="#738A9C" Font-Bold="True" ForeColor="#F7F7F7" />
                <SortedAscendingCellStyle BackColor="#F4F4FD" />
                <SortedAscendingHeaderStyle BackColor="#5A4C9D" />
                <SortedDescendingCellStyle BackColor="#D8D8F0" />
                <SortedDescendingHeaderStyle BackColor="#3E3277" />
            </asp:GridView>
            <asp:SqlDataSource ID="DBGIS" runat="server" ConnectionString="<%$ ConnectionStrings:GISConnectionString %>" DeleteCommand="DELETE FROM [point] WHERE [ID] = @original_ID" InsertCommand="INSERT INTO [point] ([pnt_x], [pnt_y], [pnt_type], [pnt_name], [pnt_attribute]) VALUES (@pnt_x, @pnt_y, @pnt_type, @pnt_name, @pnt_attribute)" SelectCommand="SELECT * FROM [point]" UpdateCommand="UPDATE [point] SET [pnt_x] = @pnt_x, [pnt_y] = @pnt_y, [pnt_type] = @pnt_type, [pnt_name] = @pnt_name, [pnt_attribute] = @pnt_attribute WHERE [ID] = @original_ID" OldValuesParameterFormatString="original_{0}">
            <DeleteParameters>
                <asp:Parameter Name="original_ID" Type="Int32" />
            </DeleteParameters>
            <InsertParameters>
                <asp:Parameter Name="pnt_x" Type="Double" />
                <asp:Parameter Name="pnt_y" Type="Double" />
                <asp:Parameter Name="pnt_type" Type="String" />
                <asp:Parameter Name="pnt_name" Type="String" />
                <asp:Parameter Name="pnt_attribute" Type="String" />
            </InsertParameters>
            <UpdateParameters>
                <asp:Parameter Name="pnt_x" Type="Double" />
                <asp:Parameter Name="pnt_y" Type="Double" />
                <asp:Parameter Name="pnt_type" Type="String" />
                <asp:Parameter Name="pnt_name" Type="String" />
                <asp:Parameter Name="pnt_attribute" Type="String" />
                <asp:Parameter Name="original_ID" Type="Int32" />
            </UpdateParameters>
        </asp:SqlDataSource>
        </div>
    </form>
    <hr />
    <form>
        <%--地图容器--%>
        <div id="mapCon" style="width: 100%; position:absolute;  display:block" >
            <%--鼠标位置控件--%>
            <div id="mouse-position"></div>
        </div>
    </form>
    <%--图形属性信息设置对话框--%>
    <div id="dialog-confirm" title="图形属性信息设置">
        <label>类型(pnt_Type):</label>
        <select id="pnt_Type" name="D1">
            <option value="学校" selected="selected" >学校</option>
            <option value="医院" >医院</option>
            <option value="景点" >景点</option>
            <option value="火车站" >火车站</option>
            <option value="其他" >其他</option>
        </select>
        <br />
        <label>名称(pnt_name):</label>
        <input type="text" value="" id="pnt_name" />
        <br />
        <label>描述(pnt_attribute):</label>
        <input type="text" value="" id="pnt_attribute" />
    </div>    
</body>
</html>
<script type="text/javascript">

        //实例化鼠标位置控件
        var mousePositionControl = new ol.control.MousePosition({
            //坐标格式
            coordinateFormat: ol.coordinate.createStringXY(4),
            //地图投影坐标系（若未设置则默认输出投影坐标系下的坐标）
            //projection: 'EPSG:4326',
            //坐标信息显示样式类名，默认是'ol-mouse-position'
            className: 'custom-mouse-position',
            //显示鼠标位置信息的目标容器
            target: document.getElementById('mouse-position'),
            //未定义坐标的标记
            undefinedHTML: '&nbsp;'
        });

        var tileLayer = new ol.layer.Tile({
            title: "天地图矢量图层",
            source: new ol.source.XYZ({
                url: "http://t0.tianditu.com/DataServer?T=vec_w&x={x}&y={y}&l={z}",
                wrapX: false
            })
        });
        var markLayer = new ol.layer.Tile({
            title: "注记图层",
            source: new ol.source.XYZ({
                url: "http://t3.tianditu.com/DataServer?T=cva_w&x={x}&y={y}&l={z}",
                wrapX: false
            })
        });

        var map = new ol.Map({
            //地图容器div的ID
            target: 'mapCon',
            //地图容器中加载的图层
            layers: [tileLayer, markLayer],
            //投影信息
            //projection: 'EPSG:4326',
            //地图视图设置
            view: new ol.View({
                //地图的中心点(怎么转换为地理投影（经纬度表示）？？？？)
                center: [12734465.7, 3570680.5],
                //地图初始显示的级别
                zoom: 13
            }),
            //加载控件到地图容器中
            controls: ol.control.defaults({
                //地图中的默认控件
                attributionOptions: ({
                    //地图数据源信息控件是否可伸缩，默认为true
                    collapsible: true
                })
            }).extend([mousePositionControl])//加载鼠标位置控件
        });
        
        //==========================================================================
        //实例化一个矢量图层Vector作为绘制层
        var vector = new ol.layer.Vector({
            source: new ol.source.Vector(),
            style: new ol.style.Style({
                fill: new ol.style.Fill({
                    color: 'rgba(255, 255, 255, 0.7)'
                }),
                stroke: new ol.style.Stroke({
                    color: '#0099ff',
                    width: 2
                }),
                image: new ol.style.Circle({
                    radius: 7,
                    fill: new ol.style.Fill({
                        color: '#0099ff'
                    })
                })
            })
        });
        map.addLayer(vector);

        //==========================================================================
        //添加表格中的点
        function DrawPoints() { 
            ////添加矢量图层作为绘制图层
            var vectorSource = new ol.source.Vector({ wrapX: false });
            var vectorLayer = new ol.layer.Vector({
                source: vectorSource,
                style: new ol.style.Style({        //样式
                    fill: new ol.style.Fill({      //填充样式
                        color: 'rgba(255,255,255,0.2)'
                    }),
                    stroke: new ol.style.Stroke({
                        color: '#ffcc33',
                        width: 2
                    }),
                    image: new ol.style.Circle({
                        radius: 7,
                        fill: new ol.style.Fill({
                            color: '#00ffff'
                        })
                    })
                })
            });


            var p_x, p_y;
            var point;
            var coordinate;
            var gv = document.getElementById("<%= gvGIS.ClientID%>");
            for (var i = 1; i < gv.rows.length; i++) {
                p_x = gv.rows[i].cells[1].innerText;
                p_y = gv.rows[i].cells[2].innerText;
                coordinate = [parseFloat(p_x), parseFloat(p_y)];
                point = new ol.Feature({
                    geometry: new ol.geom.Point(coordinate)
                })
                vectorSource.addFeature(point);//添加要素
            }
            map.addLayer(vectorLayer);
    }

    window.onload = DrawPoints;

        //==========================================================================
        //以下是交互添加点并保存的代码
        var draw; //绘制对象
        var coordinates = null;// 当前绘制图形的坐标串
        var currentFeature = null; //当前绘制的几何要素
        var geostr = null;

        /**
        * 根据绘制类型进行交互绘制图形处理
        */
        //交互添加点
            function AddPoint() {
            draw = new ol.interaction.Draw({
                source: vector.getSource(), //绘制层数据源
                type: 'Point' //几何图形类型
            });
            map.addInteraction(draw);
            //添加绘制结束事件监听，在绘制结束后保存信息到数据库
            draw.on('drawend', drawEndCallBack,this);
        }

         /**
        * 绘制结束事件的回调函数，
        * @param {ol.interaction.DrawEvent} evt 绘制结束事件
        */
        function drawEndCallBack(evt) {
            var geoType = $("#pnt_Type:selected").val();//绘制图形类型          
            $("#dialog-confirm").dialog("open"); //打开属性信息设置对话框
            currentFeature = evt.feature; //当前绘制的要素
            var geo = currentFeature.getGeometry(); //获取要素的几何信息
            coordinates = geo.getCoordinates(); //获取几何坐标
            geostr = coordinates.join(";");
            ////将几何坐标拼接为字符串
            //if (geoType == "Polygon") {
            //    geoStr = coordinates[0].join(";"); 
            //}
            //else { 
            //    geoStr = coordinates.join(";"); 
            //}          
        }

         /**
        * 将绘制的几何数据与对话框设置的属性数据提交到后台处理
        */
    function submitData() {
            
            var type = $("#pnt_Type option:selected").val(); //绘制图形类型

            var name = $("#pnt_name").val(); //名称
            var attribute = $("#pnt_attribute").val(); //所属城市

        if (coordinates != null) {
            saveData(type, geostr, name, attribute); //将数据提交到后台处理（保存到数据库中）
                currentFeature = null;  //置空当前绘制的几何要素
                coordinates = null; //置空当前绘制图形的coordinates
            }
            else {
                alert("未得到绘制图形几何信息！");
                vector.getSource().removeFeature(currentFeature); //删除当前绘制图形
            }
        }

        /**
        * 提交数据到后台保存
        * @param {string} type 绘制的几何类型
        * @param {string} geoData 几何数据
        * @param {string} attribute 属性数据
        * @param {string} name 名称
        */
        function saveData(type,geoData, name,attribute) {
            //通过ajax请求将数据传到后台文件进行保存处理
            $.ajax({
                url: 'DataHandler.ashx', //请求地址
                type: 'POST',  //请求方式为post
                data: { 'type': type, 'geo': geoData, 'name': name, 'att': attribute }, //传入参数 
                dataType: 'text', //返回数据格式
                //请求成功完成后要执行的方法  
                success: function (response) {
                    alert(response);
                },
                error: function (err) {
                    alert("执行失败");
                }
            });
        }

          // 初始化信息设置对话框
        $("#dialog-confirm").dialog(
            {
                modal: true,  // 创建模式对话框
                autoOpen: false, //默认隐藏对话框
                //对话框打开时默认设置
                open: function (event, ui) {
                    $(".ui-dialog-titlebar-close", $(this).parent()).hide(); //隐藏默认的关闭按钮
                    
                },
                //对话框功能按钮
                buttons: {
                    "提交": function () {
                        submitData(); //提交几何与属性信息到后台处理
                        $(this).dialog('close'); //关闭对话框
                    },
                    "取消": function () {
                        $(this).dialog('close'); //关闭对话框                     
                        vector.getSource().removeFeature(currentFeature); //删除当前绘制图形
                    }
                }
            });

       
        //移除交互事件
        function CancelAdd() {
            map.removeInteraction(draw);
        }

</script>
