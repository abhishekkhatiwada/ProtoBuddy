// Container(
          
//           child: postData.when(
//             data: (data) {
//               return ListView.builder(
//                   scrollDirection: Axis.vertical,
//                   itemCount: data.length,
//                   itemBuilder: (context, index) {
//                     final dat = data[index];
//                     return Padding(
//                       padding: EdgeInsets.only(top: 20, left: 20, right: 20),
//                       child: Container(
//                         child: Column(
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(dat.creatorName),
//                                 // if (userId == dat.userId)
//                                 IconButton(
//                                     onPressed: () {},
//                                     icon: Icon(Icons.more_horiz_rounded))
//                               ],
//                             ),
//                             Flexible(child: Text(dat.description)),
//                             SizedBox(
//                               height: 10,
//                             ),
//                             Image.network(dat.imageUrl),
//                             // Row(
//                             //   children: [
//                             //     IconButton(
//                             //         onPressed: () {},
//                             //         icon: Icon(Icons.thumb_up_alt_rounded)),
//                             //   ],
//                             // ),
//                           ],
//                         ),
//                       ),
//                     );
//                   });
//             },
//             error: (error, stackTrace) => Text('$error'),
//             loading: () => Container(),
//           ),
//         ),