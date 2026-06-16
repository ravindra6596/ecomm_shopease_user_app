// ignore_for_file: must_be_immutable
import 'package:auto_route/annotations.dart';
import 'package:e_comm_user/utils/colors.dart';
import 'package:e_comm_user/utils/constants.dart';
import 'package:e_comm_user/utils/strings.dart';
import 'package:e_comm_user/widgets/custom_appbar.dart';
import 'package:e_comm_user/widgets/custom_text.dart';
import 'package:e_comm_user/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

@RoutePage()
class FAQScreen extends StatelessWidget {
  FAQScreen({super.key});
  var searchController = TextEditingController();
  final ValueNotifier<String> searchQuery = ValueNotifier("");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: CustomAppBar(
        title: faqs,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(4.w),
            child: CustomTextField(
              controller: searchController,
              hintText: faqQuestion,
              prefixIcon: Icons.search,
              onChanged: (value) {
                searchQuery.value = value.toLowerCase();
              }, labelText: '',
              onSubmitted: (value) {
                searchQuery.value = value.toLowerCase();
              },
              textInputAction: TextInputAction.search,
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
                valueListenable: searchQuery,
                builder: (context, query, _) {
                  final filteredList = faqList.where((item) {
                    final q = item["question"]!.toLowerCase();
                    final a = item["answer"]!.toLowerCase();
                    return q.contains(query) || a.contains(query);
                  }).toList();
                return ListView.separated(
                  padding: EdgeInsets.all(4.w),
                  itemCount: filteredList.length,
                  separatorBuilder: (_, __) => SizedBox(height: 1.5.h),
                  itemBuilder: (context, index) {
                    final faqItem = filteredList[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(1.h),
                        border: Border.all(
                          color: dividerColor,
                        ),
                      ),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          dividerColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          colorScheme: ColorScheme.light(
                            surface: Colors.transparent,
                          ),
                        ),
                        child: ExpansionTile(
                          tilePadding: EdgeInsets.symmetric(horizontal: 4.w),
                          childrenPadding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 2.h,),
                          iconColor: primaryColor,
                          collapsedIconColor: greyColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(1.h),
                          ),
                          title: CustomText(
                            text: faqItem['question'] ?? '',
                            style: CustomTextStyle.semiBold,
                            fontSize: 15.px,
                            color: blackColor,
                            maxLines: 2,
                          ),
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: CustomText(
                                text: faqItem['answer'] ?? '',
                                style: CustomTextStyle.medium,
                                fontSize: 14.px,
                                color: greyColor,
                                maxLines: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            ),
          ),
        ],
      ),
    );
  }
}