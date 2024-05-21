import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_rental_app/constants/app_colors.dart';
import 'custom_text_field.dart';

class SearchDropDown extends StatelessWidget {
  const SearchDropDown(
      {super.key,
      required this.hintText,
      required this.dropdownItems,
      this.onChanged,
      required this.selectedValue,
      required this.controller});

  final String selectedValue;
  final String hintText;
  final List<String> dropdownItems;
  final ValueChanged<String?>? onChanged;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: Text(
          hintText,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF808080),
          ),
        ),
        items: dropdownItems
            .map(
              (item) => DropdownMenuItem(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF808080),
                    fontSize: 12,
                    fontFamily: 'Avenir',
                  ),
                ),
              ),
            )
            .toList(),
        value: selectedValue,
        onChanged: onChanged,

        /* (value) {
              selectedValue.value = value!;
            },*/
        buttonStyleData: ButtonStyleData(
          decoration: BoxDecoration(
              border: Border.all(width: 1.2, color: greyBorderColor),
              borderRadius: BorderRadius.circular(8),
              color: whiteColor),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          height: 50,
          width: Get.width,
        ),
        
        dropdownStyleData: DropdownStyleData(
          offset: const Offset(0, -6),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8), color: whiteColor),
          maxHeight: 330,
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 50,
        ),

        iconStyleData: IconStyleData(
          icon:
              // Icon(Icons.keyboard_arrow_down)
              Image.asset(
            'assets/icons/down_angle.png',
            alignment: Alignment.centerRight,
            scale: 4,
          ),
        ),
        dropdownSearchData: DropdownSearchData(
          searchController: controller,
          searchInnerWidgetHeight: 50,
          searchInnerWidget: Container(
            height: 50,
            color: whiteColor,
            padding: const EdgeInsets.only(
              top: 8,
              bottom: 4,
              right: 8,
              left: 8,
            ),
            child: CustomTextField(
              hintText: hintText,
              controller: controller,
            ),
          ),
          searchMatchFn: (item, searchValue) {
            return item.value.toString().contains(searchValue);

          },
        ),

        //This to clear the search value when you close the menu
        onMenuStateChange: (isOpen) {
          if (!isOpen) {
            controller.clear();
          }
        },
      ),
    );
  }
}
