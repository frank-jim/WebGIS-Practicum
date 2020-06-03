<%--
  Created by IntelliJ IDEA.
  User: 廖成
  Date: 2020/5/26
  Time: 10:43
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="DAO.DButil" %>

<%@ page contentType="text/html;charset=UTF-8" import="DAO.jdbcUtiles" language="java" %>
<html>
<head>
    <title>坐标点检测</title>
    <script src="resource/js/ol.js"></script>
    <link rel="stylesheet" href="resource/css/ol.css" type="text/css">
    <link rel="stylesheet" href="resource/css/popup.css">
<%--    element ui 引入  --%>
    <!-- 引入样式 -->
    <link rel="stylesheet" href="https://unpkg.com/element-ui/lib/theme-chalk/index.css">


    <style>
        .map{
            position: absolute;
            height: 100%;
            width: 100%;
            z-index: 2;
        }
        body{
            margin: 0px;
            padding: 0px;
        }
        #search_area{
            float: left;
            margin-left: 50px;
            margin-top: 50px;
            z-index: 1;
            position: fixed;
        }
        #search-div{
            width: 350px;
            height: 40px;
            text-align: center;
        }
        #search-input{
            width: 300px;
            height: 30px;
            margin-top: 5px;
        }
        .poilist{
            list-style: none;
            background-color: #b1abab;
            padding: 0;
            margin: 0;
        }
        .div-l{
            float:left;
            width:49%;
        }
        .div-r{
            float:left;
            width:49%;
        }
        .poi-item{
            font-size: 12px;
            height: 60px;
            text-align: center;
            display: flex;
            align-items: center;
        }
        .poi-item:hover{
            background-color: #ffffff;
        }
        .poi-picture{
            height: 30px;
            width: 30px;
            border-radius: 15px;
            text-align: center;
        }
        .poi-detail{
            padding: 3px;
        }
        #details-form{
            background-color: #D2D2D2;
            border-radius: 10px;
        }
        form p {
            margin: 10px;
            padding: 5px;
        }
        label,input {
            vertical-align: middle;
        }
        label {
            width: 80px;
            display: inline-block;
        }
        input {
            width: 200px;
        }
        textarea{
            width: 200px;
            height: 80px;
        }
        #login_area{
            float: right;
            margin-left: 1400px;
            margin-top: 50px;
            z-index: 3;
            position:fixed ;
            background-color: #1E9FFF;
        }
    </style>

</head>
<body>
    <div id="search_area">
        <div id="search-div">
            <input type="text" class="input" id = "search-input"/>
            <button id = "search-button" onclick="OnSearch()">检索</button>
        </div>
        <ul  class="poilist" id="poi-list">
<%--            <li class="poi-item">--%>
<%--                <div class="div-l">--%>
<%--                    <div class="poi-detail">--%>
<%--                        <span id="city-name">--%>
<%--                            城市名称--%>
<%--                        </span>--%>
<%--                    </div >--%>
<%--                    <div class="poi-detail">--%>
<%--                        <span id="city-pinyin">--%>
<%--                            城市拼音--%>
<%--                        </span>--%>
<%--                    </div>--%>
<%--                    <div class="poi-detail">--%>
<%--                        <span id="city-details">--%>
<%--                            城市编码--%>
<%--                        </span>--%>
<%--                    </div>--%>
<%--                </div>--%>
<%--                <div class="div-r">--%>
<%--                    <img id="city-picture" class="poi-picture"  src="resource/image/locate.png" alt="城市详情图片" />--%>
<%--                </div>--%>
<%--            </li>--%>
        </ul>
        <form id="details-form">
            <div>
<%--                <p><label>城市: </label><input type="text" name="name" /></p>--%>
<%--                <p><label>坐标: </label>X: <input type="text" name="coords-X" style="width: 60px"/> Y: <input type="text"--%>
<%--                                                                                               name="coords-Y" style="width: 60px"/></p>--%>
<%--                <p><label>城市详情: </label><textarea name="introduce" ></textarea></p>--%>
<%--    &lt;%&ndash;            判断时候有图片，如果有图片就直接传递，如果没有就展示传递图片选择框&ndash;%&gt;--%>
<%--                <p><label>城市图片: </label><input type="file" name="city_image" ></p>--%>
<%--                <p><label>城市图片: </label><img type="image" name="city_image" src="resource/image/res2_4m.png"></p>--%>
<%--                <p><label>城市编码: </label><input type="text" name="coordinates" /></p>--%>
<%--                <div style="text-align: center;padding: 5px">--%>
<%--                    <select style="text-align: center;padding: 1px">--%>
<%--                        <option value="name">名称</option>--%>
<%--                        <option value="coord">坐标</option>--%>
<%--                        <option value="image">图片</option>--%>
<%--                        <option value="intro">介绍</option>--%>
<%--                        <option value="adcode99">城市编码</option>--%>
<%--                    </select>--%>
<%--                    <button type="button" style="width: 100px;border-radius: 5px;text-align: center">--%>
<%--                    修改信息 </button></div>--%>
            </div>
        </form>
        <div id="popup" class="ol-popup">
            <a href="#" id="popup-closer" class="ol-popup-closer"></a>
            <div id="popup-content"></div>
        </div>
    </div>
    <div id="app">
        <register_cpn ref="aaa"></register_cpn>
    </div>
<%--登录注册部分，两个标签--%>
    <template>
        <el-tabs v-model="activeName" @tab-click="handleClick">
            <el-tab-pane label="用户管理" name="first">登录</el-tab-pane>
            <el-tab-pane label="配置管理" name="second">注册</el-tab-pane>
        </el-tabs>
    </template>
<%--    登录部分--%>

    <template id="register_cpn">
        <el-form :model="ruleForm"  ref="ruleForm" label-width="100px" class="demo-ruleForm">
            <el-form-item label="用户名" prop="username">
                <el-input v-model="ruleForm.username"></el-input>
            </el-form-item>
            <el-form-item label="密码" prop="password">
                <el-input v-model="ruleForm.password"></el-input>
            </el-form-item>
            <el-form-item>
                <el-button type="primary" @click="submitForm('a')" >提交</el-button>
                <el-button @click="resetForm('ruleForm')">重置</el-button>
            </el-form-item>
        </el-form>

    </template>
    <div id="login_area">
        注册部分
    </div>
    <div id="map">
    </div>
    <script src="resource/js/ol.js"></script>
    <script type="text/javascript" src = "resource/js/jquery-3.4.1.min.js"></script>
    <script type="text/javascript" src  = "resource/js/app.js"></script>
    <script type="text/javascript" src  = "resource/js/OSM_merge.js"></script>
    <script type="text/javascript" src = "resource/js/merge_pop.js"></script>

    <!-- import Vue before Element -->
    <script src="resource/js/vue.js" type="text/javascript"></script>
    <!-- import JavaScript -->
    <script src="https://unpkg.com/element-ui/lib/index.js"></script>


    <script type="text/javascript" >
        const geojson =<%
            String geojson = DButil.SelectAll("SELECT name as name,ST_AsGeoJson(geom) as geom  from res2_4m");
            out.print(geojson);
        %>
//------------------------     Openlayers  style部分  --------------------------------------------------------------//

        console.log(geojson);
        //矢量样式
        let fill = new ol.style.Fill({
            color: 'rgba(255,141,155,0.6)'
        });
        let stroke = new ol.style.Stroke({
            color: '#3399CC',
            width: 1.25
        });
        let iconStyle =new ol.style.Icon(({
                scale:0.05,
                src: 'resource/image/res2_4m.png'
        }));
        let locateStyle = new ol.style.Icon({
            anchor:[0.5,1],// 用图标的哪一点放到定位点上
            // anchorOrigin:"top-right",// 锚点的起算位置
            // anchorXUnits:"fraction",//锚点的x，y单位， fraction表示百分比
            scale:0.15,
            src:'resource/image/locate2.png'
        })
        const styleVector = new ol.style.Style({
            stroke: stroke,
            fill: fill,
            // image:new ol.style.Circle({
            //     radius: 2,
            //     fill:new ol.style.Fill({
            //         color: 'rgb(255,0,0)'
            //         })
            //     }),
            image:locateStyle
        })
//---------------------------------- openlayers  图层控制部分         -----------------------------//
        var searchFeatures;

        let foreign_id;//整个建设要素的id

        var vectorSource = new ol.source.Vector({});
        const vectorLayer = new ol.layer.Vector({
            source: vectorSource,
            style: styleVector
        });
        //加入数据
        vectorSource.addFeatures((new ol.format.GeoJSON()).readFeatures(geojson));
        map.addLayer(vectorLayer);

        //配置检索结果

        //矢量标注样式设置函数，设置image为图标ol.style.Icon
        function createLabelStyle(feature){
            return new ol.style.Style({
                image: locateStyle,
                text: new ol.style.Text({
                    textAlign: 'middle',            //位置
                    textBaseline: 'hanging',         //基准线
                    font: 'normal 14px 微软雅黑',    //文字样式
                    offsetY:4,
                    text: feature.get('name'),      //文本内容
                    fill: new ol.style.Fill({       //文本填充样式（即文字颜色)
                        color: '#000'
                    })
                })
            });
        }
        function createFeatureByGeoJson(geojson) {
            //清除矢量内容
            vectorSource.clear(true);
            //渲染搜索结果
            let features = JSON.parse(geojson).features;
            searchFeatures = JSON.parse(geojson).features;
            setFeaturesTable(features)
            for(let i=0;i<features.length;i++){
                //这里通过函数更新表单，产生结果数据
                
                let coordinate = features[i].geometry.coordinates;//坐标数据
                let name = features[i].properties.name;
                let newFeature = new ol.Feature({
                    geometry: new ol.geom.Point(coordinate),  //几何信息
                    name: name
                });
                newFeature.setStyle(createLabelStyle(newFeature));      //设置要素样式
                vectorSource.addFeature(newFeature);
            }
        }

        $('#search-input').bind('keypress',function(event){
            if(event.keyCode == 13)
            {
                OnSearch();
            }

        });
        function OnSearch() {
            clearInfoTable();
            clearSearchTable();
            //根据搜索框内容发送Ajax请求
            let seachInput = document.getElementById("search-input");
            let inputStr = seachInput.value;
            if(inputStr !=null && inputStr!=="" && inputStr!==undefined){
                $.ajax({
                    url:"./SearchServlet",
                    data:{
                        name:inputStr
                    },
                    type:"POST",
                    dataType:"json",
                    success:function (data) {
                        if(data.status===200){

                            var geojson = data.data.geojson;
                            //实例化整个geojson
                            console.log(JSON.parse(geojson).features);
                            createFeatureByGeoJson(geojson);
                            // vectorSource.clear(true);
                            // vectorSource.addFeatures((new ol.format.GeoJSON()).readFeatures(geojson));
                        }
                        else {
                            clearSearchTable();
                        }
                    }
                })
            }
            else {
                clearSearchTable();
                console.log("空");
            }
        }

    //-------------------------------------动态添加table 函数部分------------------------------------------------//

        //清空展示框
        function clearSearchTable() {
            let ul = document.getElementById("poi-list")
            if(ul!=null){
                ul.innerText = "";
            }
        }

        function setFeaturesTable(features) {
            let ul = document.getElementById("poi-list")
            ul.innerText = "";
            console.log(features);
            let li = '';
        //    传入图层，输出html
            for(let i=0;i<features.length;i++){
                //这里通过函数更新表单，产生结果数据

                let name = features[i].properties.name;
                let pinyin = features[i].properties.pinyin;
                let code = features[i].properties.adcode99;
                let id = features[i].properties.id;
                // let imageUrl = features[i].properties.imageUrl;
                let imageUrl = 'resource/image/locate.png'
                li = `
            <li class="poi-item" id="`+id+`" index="`+i+`">
                <div class="div-l">
                    <div class="poi-detail">
                        <span id="city-name">
                            `+name+`
                        </span>
                    </div >
                    <div class="poi-detail">
                        <span id="city-pinyin">
                            `+pinyin+`
                        </span>
                    </div>
                    <div class="poi-detail">
                        <span id="city-details">
                            `+code+`
                        </span>
                    </div>
                </div>
                <div class="div-r">
                    <img id="city-picture" class="poi-picture"  src=`+ imageUrl+` alt="城市详情图片" />
                </div>
            </li>`
                ul.insertAdjacentHTML('beforeend',li);
                //生成时绑定事件

            }
        }

        //---------------------------- 展示详细信息-------------------------------------//
        //响应某一个poi-item的点击事件 然后发送info请求
        //动态绑定事件， 发送ajax请求， 得到详情页面，
        $("#poi-list").on('click',' .poi-item',function (e) {
            let fid = e.currentTarget.id;
            //页面的中心点跳转，
            let index = e.currentTarget.getAttribute("index");
            let feature = searchFeatures[index];
            let coords = feature.geometry.coordinates;
            mapView.setCenter(coords);
            mapView.setZoom(6);
            //页面的中心点跳转，
            //ajax 查询详细信息
            $.ajax({
                url:"./infoServlet",
                data:{
                    fid:fid
                },
                type:"POST",
                dataType:"json",
                success:function (data) {
                    if(data.status===200){
                        clearInfoTable();
                        clearSearchTable();
                        //需要通过建立html插入数据表单
                        var geojson = data.data.geojson;
                        //实例化整个geojson
                        let feature = JSON.parse(geojson).features[0];
                        showInfoForm(feature)

                    }
                    else {
                        alert("未检索到结果");
                    }
                }
            })
        })
        //清空详情框
        function clearInfoTable() {
            let form = document.getElementById("details-form");
            if(form!=null){
                form.innerText = "";
            }
        }

        //查询结果，getinfo，然后展示到地图上
        function showInfoForm(feature) {
            let form = document.getElementById("details-form");
            clearInfoTable();
            //装配信息
            let properties = feature.properties;
            let name = properties.name;
            let pinyin = properties.pinyin;
            let intro = properties.intro;
            let image = properties.image;
            console.log(image+"这是图片的内容");
            console.log(image==null)
            let coordinates = feature.geometry.coordinates;
            let adcode99 = properties.adcode99;
            foreign_id = properties.id;
            console.log(foreign_id);
            //构建html
            let innerHtml = `
            <p><label>城市: </label><input type="text" name="name"  value="`+name+`" id="details-name"/></p>
            <p><label>坐标: </label>X: <input type="text" name="coords-X" style="width: 70px" value="`+coordinates[0]+`" /> Y: <input type="text"
                                                                                           name="coords-Y" style="width: 70px"  value="`+coordinates[1]+`"/></p>
            <p><label>城市详情: </label><textarea name="introduce" id="details-intro" >`+intro+`</textarea></p>`
                +getImageHtml(image)+
                `<p><label>城市编码: </label><input type="text" id="details-adcode99" name="code" value="`+adcode99+`"/></p>
            <div style="text-align: center;padding: 5px;">
                    <select style="text-align: center;padding: 1px" id="modify-select">
<!--                        <option value="name">名称</option>-->
<!--                        <option value="coord">坐标</option>-->
                        <option value="image">图片</option>
                        <option value="intro">介绍</option>
<!--                        <option value="adcode99">城市编码</option>-->
                    </select>
                    <button type="button" onclick="updateInfo()"  id="modify-info" style="width: 100px;border-radius: 5px;text-align: center">
                    修改信息 </button></div>`;


            form.insertAdjacentHTML("beforeend",innerHtml);

        }

        function updateInfo() {
            console.log("++++++++++++++++++");
            //还需要取得 修改的id
            //得到修改结果  首先判断修改类型，实际上后面开发时利用Vue v-if 使得非修改编辑框为disable，绑定,
            let sel = document.getElementById("modify-select");

            let type = sel.value;
            //得到参数
            let content = document.getElementById('details-'+type).value;


            //文件上传需要先转化为base字符串：这里进行更改
            if(type==='image'){
                //content 是文件路径
                let reader = new FileReader();
                reader.onload=function(e){
                    //加载完毕后进行数据传递，！！这里注意，必须要在这个函数内才有数据，这个函数表示图片数据转换成功
                    content = reader.result;  //或者 e.target.result都是一样的，都是base64码
                    console.log(content)
                    $.ajax({
                        url:"./UpdateInfoServlet",
                        data:{
                            type:type,
                            content:content,
                            fid:foreign_id
                        },
                        type:"POST",
                        dataType:"json",
                        success:function (data) {
                            if(data.status===200){
                                //更新成功后重新刷新列表
                                clearInfoTable();
                                clearSearchTable();
                                //需要通过建立html插入数据表单
                                var geojson = data.data.geojson;
                                //实例化整个geojson
                                let feature = JSON.parse(geojson).features[0];
                                showInfoForm(feature);
                                alert('信息修改成功');

                            }
                            else {
                                alert(data.data.error);
                            }
                        }
                    })
                    return;
                };
                reader.readAsDataURL(document.getElementById('details-'+type).files[0]);

            }

            else {
                //这里发送请求！！
                $.ajax({
                    url:"./UpdateInfoServlet",
                    data:{
                        type:type,
                        content:content,
                        fid:foreign_id
                    },
                    type:"POST",
                    dataType:"json",
                    success:function (data) {
                        if(data.status===200){
                            //更新成功后重新刷新列表
                            clearInfoTable();
                            clearSearchTable();
                            //需要通过建立html插入数据表单
                            var geojson = data.data.geojson;
                            //实例化整个geojson
                            let feature = JSON.parse(geojson).features[0];
                            showInfoForm(feature);
                            alert('信息修改成功');

                        }
                        else {
                            alert(data.data.error);
                        }
                    }
                })
            }



        }
        function getImageHtml(image) {
            if(image==null){
                return `<p><label>城市图片: </label>
                <input type="file" name="city_image" id="details-image" accept="image/png,image/gif,image/jpeg" ></p>`;
            }
            else {
                //object-fit 设置图片等比例缩放
                return `<p><label>城市图片: </label><img type="image" name="city_image" src="`+
                image+`" style="height: 130px;width: 130px;margin-left: 20px;object-fit:contain"></p>
                <p><label>重新上传: </label><input type="file" name="city_image" id="details-image" accept="image/png,image/gif,image/jpeg"></p>`;
            }
        }
    //---------------------------------------  注册登录，权限部分 ----------------------------------------------------------//
        let app = new Vue({
            el: '#app',
            data: function() {
                return { visible: false }
            },
            components:{
                register_cpn:{
                    template:"#register_cpn",
                    data(){
                        return{
                            ruleForm:{
                                name:"",
                                password:"",
                                username:""
                            },
                            rules: {
                                pass: [
                                    { validator: this.methods.validatePass, trigger: 'blur' }
                                ],
                                checkPass: [
                                    { validator: this.methods.validatePass2, trigger: 'blur' }
                                ],
                                age: [
                                    { validator: this.methods.checkAge, trigger: 'blur' }
                                ]
                            }
                        }
                    },
                    methods: {
                        //验证信息
                        submitForm(formName) {
                            this.validate((valid) => {
                                if (valid) {
                                    alert('submit!');
                                } else {
                                    console.log('error submit!!');
                                    return false;
                                }
                            });
                            console.log("信息提交")
                        },
                        resetForm(formName) {
                            //这里在哪？
                            console.log("重置信息")
                            this.$refs[formName].resetFields()
                        },
                        validatePass2: (rule, value, callback) => {
                            if (value === '') {
                                callback(new Error('请再次输入密码'));
                            } else if (value !== this.ruleForm.pass) {
                                callback(new Error('两次输入密码不一致!'));
                            } else {
                                callback();
                            }
                        },
                        validatePass: (rule, value, callback) => {
                            if (value === '') {
                                callback(new Error('请输入密码'));
                            } else {
                                if (this.ruleForm.checkPass !== '') {
                                    this.$refs.ruleForm.validateField('checkPass');
                                }
                                callback();
                            }
                        },
                        checkAge: (rule, value, callback) => {
                            if (!value) {
                                return callback(new Error('年龄不能为空'));
                            }
                            setTimeout(() => {
                                if (!Number.isInteger(value)) {
                                    callback(new Error('请输入数字值'));
                                } else {
                                    if (value < 18) {
                                        callback(new Error('必须年满18岁'));
                                    } else {
                                        callback();
                                    }
                                }
                            }, 1000);
                        }
                    }
                }
            },
        })

    </script>

</body>
</html>