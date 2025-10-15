import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talk/constants/colors.dart';

class BackgroundContainer extends StatelessWidget {
  final Widget child;

  const BackgroundContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bgcolor,
      width: MediaQuery.of(context).size.width,
      child: child,
    );
  }
}

class InputField extends StatelessWidget {
  final String label;
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final TextEditingController controller; // Add this line

  const InputField({
    super.key,
    required this.label,
    required this.hintText,
    required this.icon,
    required this.controller, // Add this line
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.h,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 20.w, top: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Urbanist',
                fontSize: 13.sp,
              ),
            ),
            Row(
              children: [
                Icon(icon, size: 20.sp, color: Colors.grey),
                SizedBox(width: 10.w),
                Expanded(
                  child: TextFormField(
                    controller: controller, // Add the controller here
                    decoration: InputDecoration(
                      hintText: hintText,
                      hintStyle: TextStyle(
                        fontFamily: 'Urbanist',
                        color: Colors.grey.shade600,
                        fontSize: 14.sp,
                      ),
                      border: InputBorder.none,
                    ),
                    obscureText: obscureText,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TextFieldWithIcon extends StatefulWidget {
  final String labelText;
  final IconData icon;
  final String? hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final double iconSize;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final VoidCallback? onTap;       // ✅ Add this
  final bool readOnly;

  const TextFieldWithIcon({
    super.key,
    this.validator,
    required this.labelText,
    required this.icon,
    this.hintText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.iconSize = 24.0,
    this.controller,
    this.onTap,
    this.readOnly = false,
  });

  @override
  State<TextFieldWithIcon> createState() => _TextFieldWithIconState();
}

class _TextFieldWithIconState extends State<TextFieldWithIcon> {
  late bool _isObscure;

  @override
  void initState() {
    super.initState();
    _isObscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.labelText,
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Urbanist',
            fontSize: 15.sp,
          ),
        ),
        const SizedBox(height: 8.0),
        Padding(
          padding: EdgeInsets.only(left: 10.w),
          child: Row(
            children: [
              Icon(
                widget.icon,
                color: Colors.grey,
                size: widget.iconSize,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: TextFormField(
                  readOnly: widget.readOnly,         // ✅ Pass it to TextFormField
                  onTap: widget.onTap,
                  controller: widget.controller,
                  validator: widget.validator, // ✅ Now works correctly
                  obscureText: _isObscure,
                  keyboardType: widget.keyboardType,
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 14.sp,
                      fontFamily: 'Urbanist',
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                    suffixIcon: widget.obscureText
                        ? IconButton(
                      icon: Icon(
                        _isObscure
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                    )
                        : null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

