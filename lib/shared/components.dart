import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/cubit/cubit.dart';

Widget defaultButton({
  double ? width = double.infinity ,
   Color ? background = Colors.blue,
    bool isUpperCase = true,
  double radius = 0.0,
  required void Function()? function , //  خلي بالك من دي
  required String  text ,
 })=>Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(radius),
    color: background,
  ),
  width: width,
  child:
  MaterialButton(
    onPressed: function,
    child:
    Text(
       isUpperCase? text.toUpperCase():text,
      style: TextStyle(
        color: Colors.white,
      ),
    ),
  ),
);
  Widget defaultFormFiled({
    bool isClicable = true,
   void Function() ?onTap,
  required TextEditingController controller,
  required TextInputType type ,
  required String? Function(String?)? Validate,
    required String? label,
    required IconData ? Prefix,
     IconData ?suffix ,
   // void  Function()? onSubmitted,
  String? Function(String?) ?onSubmitted,
   String? Function(String?)?onChange,
   bool iSPassword =  false,
     void Function () ?suffixPressed,
})=>  TextFormField(
    enabled:isClicable ,
    onTap: onTap,
    controller: controller,
    keyboardType: type ,
    obscureText: iSPassword,
    onFieldSubmitted: onSubmitted,
    onChanged: onChange,
    validator: Validate,
    decoration: InputDecoration(
      labelText:label,
      suffixIcon: suffix!= null? IconButton(
        onPressed: suffixPressed,
        icon: Icon(
            suffix
        ),
      ) : null,
      prefixIcon:
      Icon(
          Prefix,
      ),
      border: OutlineInputBorder(),
    ),
  );
  Widget bulidTaskItem(Map model, context)=>
      Dismissible(
        key: Key(model['id'].toString()),
        child: Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
        children: [
          CircleAvatar(
            radius: 40.0,
            child: Text(
                '${model['time']}'
            ),
          ),
          SizedBox(
            width: 20.0,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
            '${model['title']}',
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold
                  ),
                ),
                Text(
                    '${model['date']}',
                  style: TextStyle(
                    color: Colors.grey,
                  ),

                ),
              ],
            ),
          ),
          SizedBox(
            width: 20.0,
          ),
          IconButton
            (
              onPressed: ()
              {
                AppCubit.get(context).updateData(status: 'done', id: model['id']);
              },
              icon:Icon (
                  Icons.check_box,
                color: Colors.green,
              ),
          ),  IconButton
            (
              onPressed: ()
              {
                AppCubit.get(context).updateData(status: 'archive', id: model['id']);
              },
              icon: Icon(
                Icons.archive,
                color: Colors.black45,
              ),
          ),
        ],
    ),
  ),
        onDismissed: (direction){
          AppCubit.get(context).deleteDate(id: model['id']);
        },
      );
  Widget tasksBulider({
  required List<Map> tasks,
})=> ConditionalBuilder(
    condition:tasks.length>0 ,
    builder:(context)=>ListView.separated(itemBuilder:(context,index) => bulidTaskItem(tasks[index], context),
      separatorBuilder:(context,index)=>
      myDivider() ,
      itemCount:tasks.length,
    ),
    fallback:(context)=>Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.menu,
            size: 100,
            color: Colors.grey,
          ),
          Text(
            'No Tasks Yet, Please Add Some Tasks',
            style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey
            ),

          ),
        ],
      ),
    ) ,
  );

  Widget myDivider()=>  Container(
    width: double.infinity,
    color: Colors.grey[300],
    height: 1.0,
  ) ;

  void navigateto(context,Widget)=> Navigator.push(
context,
MaterialPageRoute(
builder: (context)=>
Widget,
),
);

  void navigateAndFinish(context,Widget)=>
      Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(
        builder: (context)=>
        Widget,
      ),
              (Route<dynamic>route) => false
      );
  Widget defaultTextButton({
    required  void Function()? function,
  required String text})
  => TextButton(onPressed: function, child: Text(text.toUpperCase()),);
