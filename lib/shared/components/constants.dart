import 'package:auto_size_text/auto_size_text.dart';
import 'loadingWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// const appPrimaryColour = '#F0F1F2';
// const appSecondaryColour = '#225c73';
// const appPrimaryColourDark = '#99b4bf';
// const appPrimaryColourLight = '#ffffff';
// const appPrimaryTextColor = '#676767';
const university = 'University';
const college = 'myCollege';
const department = 'Department';
const collegeName = 'College Name';

class HeadingText extends StatelessWidget {
  final String text;
  final Color color;
  final double size;
  final Alignment alignment;
  final FontWeight fontWeight;
  final TextAlign textAlign;

  const HeadingText(
      {Key key,
      this.color,
      this.text,
      this.size,
      this.alignment: Alignment.center,
      this.fontWeight: FontWeight.normal,
      this.textAlign})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      child: Text(
        text,
        textAlign: textAlign,
        style: GoogleFonts.poppins(
          fontSize: size,
          color: color,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}

class DecoratedContainer extends StatefulWidget {
  final Widget child;
  final Function onpressed;
  final Color color;
  final Size size;
  final Function onLongPress;
  final double heightfactor;
  final double widthfactor;
  final String backgroundImage;

  const DecoratedContainer(
      {Key key,
      this.child,
      this.onpressed,
      this.color: Colors.white,
      this.size,
      this.onLongPress,
      this.heightfactor,
      this.widthfactor = 0.9,
      this.backgroundImage})
      : super(key: key);
  @override
  _DecoratedContainerState createState() => _DecoratedContainerState();
}

class _DecoratedContainerState extends State<DecoratedContainer> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: widget.onpressed,
      onLongPress: widget.onLongPress,
      child: Container(
        // color: widget.color,
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
        width: size.width * widget.widthfactor,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.1),
                offset: Offset(6, 4),
                blurRadius: 6.0,
                spreadRadius: 0.0),
          ],
          color: Theme.of(context).primaryColorLight,
          borderRadius: BorderRadius.circular(8),
        ),
        child: widget.child,
      ),
    );
  }
}

class RoundedField extends StatefulWidget {
  final String label;
  final String text;
  final Color color;

  const RoundedField({Key key, this.text, this.color, this.label})
      : super(key: key);
  @override
  _RoundedFieldState createState() => _RoundedFieldState();
}

class _RoundedFieldState extends State<RoundedField> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black54, width: 1.0),
        color: Colors.white,
        borderRadius: BorderRadius.circular(29.0),
      ),
      margin: EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.8,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 5.0,
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              HeadingText(
                alignment: Alignment.topLeft,
                text: widget.text,
                color: widget.color,
                size: 16.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DecoratedButtonState extends StatefulWidget {
  final String text;
  final Function onPressed;
  final Color color;
  final bool loading;
  final Color textColor;

  const DecoratedButtonState(
      {Key key,
      this.text,
      this.onPressed,
      this.color,
      this.loading,
      this.textColor})
      : super(key: key);
  @override
  _DecoratedButtonStateState createState() => _DecoratedButtonStateState();
}

class _DecoratedButtonStateState extends State<DecoratedButtonState> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.8,
      decoration: new BoxDecoration(
        image: DecorationImage(
          image: new AssetImage('assets/images/collegify_cropped.png'),
          fit: BoxFit.contain,
        ),
        borderRadius: BorderRadius.circular(29.0),
      ),
    );
  }
}

class RoundedButton extends StatefulWidget {
  final String text;
  final Function onPressed;
  final Color color;
  final bool loading;
  final Color textColor;

  RoundedButton({
    this.text,
    this.color,
    this.loading,
    this.onPressed,
    this.textColor: Colors.white,
  }) : super();

  @override
  _RoundedButtonState createState() => _RoundedButtonState();
}

class _RoundedButtonState extends State<RoundedButton> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(29.0),
        // boxShadow: [
        //   BoxShadow(
        //       color: Color.fromRGBO(0, 0, 0, 0.2),
        //       offset: Offset(2, 3),
        //       blurRadius: 1.0,
        //       spreadRadius: 3.0),
        // ],
      ),
      margin: EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: TextButton(
          style: ButtonStyle(
            padding: MaterialStateProperty.all(
              EdgeInsets.symmetric(vertical: 17, horizontal: 40),
            ),
            backgroundColor: MaterialStateProperty.all(widget.color),
          ),
          onPressed: widget.onPressed,
          child: widget.loading
              ? Loader(
                  color: Theme.of(context).colorScheme.secondary,
                  size: 23,
                )
              : Text(
                  widget.text,
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.normal,
                      color: widget.textColor,
                      fontSize: 15),
                ),
        ),
      ),
    );
  }
}

class RoundedButtonExtended extends StatefulWidget {
  final String text;
  final Function onPressed;
  final Color color;
  final bool loading;
  final Color textColor;
  final Icon icon;

  const RoundedButtonExtended({
    Key key,
    this.text,
    this.onPressed,
    this.color,
    this.loading,
    this.textColor: Colors.white,
    @required this.icon,
  }) : super(key: key);

  @override
  _RoundedButtonExtendedState createState() => _RoundedButtonExtendedState();
}

class _RoundedButtonExtendedState extends State<RoundedButtonExtended> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(39.0),
        boxShadow: [
          BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              offset: Offset(6, 5),
              blurRadius: 5.0,
              spreadRadius: 2.0),
        ],
      ),
      margin: EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.8,
      height: size.height * 0.2,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29.0),
        child: TextButton(
          style: ButtonStyle(
            padding: MaterialStateProperty.all(
              EdgeInsets.symmetric(vertical: 18, horizontal: 40),
            ),
            backgroundColor: MaterialStateProperty.all(widget.color),
          ),
          onPressed: widget.onPressed,
          child: widget.loading
              ? Loader(
                  color: Theme.of(context).colorScheme.secondary,
                  size: 27,
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    widget.icon,
                    Text(
                      widget.text,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.normal,
                          color: widget.textColor,
                          fontSize: 18),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class RoundedInputField extends StatefulWidget {
  final String hintText;
  final ValueChanged<String> onChanged;
  final TextEditingController controller;
  final Color color;
  final bool boolean;
  final Function validator;
  final textInputType;
  final Icon prefixIcon;
  final IconButton suffixIcon;

  RoundedInputField({
    Key key,
    this.hintText,
    this.onChanged,
    this.controller,
    this.color,
    this.boolean = false,
    this.validator,
    this.textInputType: TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
  }) : super(key: key);

  @override
  _RoundedInputFieldState createState() => _RoundedInputFieldState();
}

class _RoundedInputFieldState extends State<RoundedInputField> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.1,
      width: size.width * 0.8,
      child: TextFormField(
        controller: widget.controller,
        keyboardType: widget.textInputType,
        //  autofocus: true,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        scrollPadding: const EdgeInsets.all(0.0),
        cursorColor: Theme.of(context).buttonTheme.colorScheme.primary,
        style: TextStyle(
          color: Theme.of(context).primaryTextTheme.bodyText1.color,
          fontSize: 13,
        ),
        validator: widget.validator,
        onChanged: widget.onChanged,
        obscureText: widget.boolean,
        decoration: InputDecoration(
          border: InputBorder.none,
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).highlightColor, width: 2.0),
            borderRadius: BorderRadius.circular(8.0),
          ),
          filled: true,
          fillColor: Theme.of(context).primaryColorLight,
          errorBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).errorColor, width: 2.0),
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).errorColor, width: 2.0),
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).focusColor, width: 2.0),
            borderRadius: BorderRadius.circular(8.0),
          ),
          errorStyle: const TextStyle(height: 1),
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.suffixIcon,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          hintText: widget.hintText,
          hintStyle: TextStyle(
              color: Theme.of(context).primaryTextTheme.bodyText1.color,
              fontSize: 13),
        ),
      ),
    );
  }
}

class TextFieldContainer extends StatefulWidget {
  final Widget child;
  final Color color;

  const TextFieldContainer({
    Key key,
    this.child,
    this.color: Colors.white,
  }) : super(key: key);

  @override
  _TextFieldContainerState createState() => _TextFieldContainerState();
}

class _TextFieldContainerState extends State<TextFieldContainer> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      width: size.width * 0.8,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black54, width: 1.0),
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: widget.child,
    );
  }
}

class RoundedInputFieldNumbers extends StatefulWidget {
  final String hintText;
  final ValueChanged<String> onChanged;
  final Color color;
  final bool boolean;
  final Function validator;
  //final List<TextInputFormatter> textInputFormatter;

  RoundedInputFieldNumbers({
    Key key,
    this.hintText,
    this.onChanged,
    this.color,
    this.boolean = false,
    this.validator,
  }) : super(key: key);

  @override
  _RoundedInputFieldNumbersState createState() =>
      _RoundedInputFieldNumbersState();
}

class _RoundedInputFieldNumbersState extends State<RoundedInputFieldNumbers> {
  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        keyboardType: TextInputType.numberWithOptions(decimal: false),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        validator: widget.validator,
        onChanged: widget.onChanged,
        obscureText: widget.boolean,
        decoration: InputDecoration(
          hintStyle:
              GoogleFonts.montserrat(color: Colors.black54, fontSize: 14),
          hintText: widget.hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class TextFieldContainerNumbers extends StatefulWidget {
  final Widget child;
  final Color color;

  const TextFieldContainerNumbers({
    Key key,
    this.child,
    this.color: Colors.white,
  }) : super(key: key);

  @override
  _TextFieldContainerNumbersState createState() =>
      _TextFieldContainerNumbersState();
}

class _TextFieldContainerNumbersState extends State<TextFieldContainerNumbers> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: size.width * 0.8,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(29),
      ),
      child: widget.child,
    );
  }
}

class AlertWidget extends StatelessWidget {
  final String message;
  final Color color;
  final IconData icon;

  final Function onpressed;
  AlertWidget(
      {this.message,
      this.onpressed,
      this.color,
      this.icon: Icons.error_outline_rounded});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (message != null) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        //padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        width: size.width * 0.8,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8.0),
        ),

        padding: EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Icon(icon),
            ),
            Expanded(
              child: AutoSizeText(
                message,
                maxLines: 3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: onpressed,
              ),
            ),
          ],
        ),
      );
    }
    return SizedBox(
      height: 0,
    );
  }
}

class RoundedInputFieldExtended extends StatefulWidget {
  final String hintText;
  final ValueChanged<String> onChanged;
  final Color color;

  final Function validator;

  const RoundedInputFieldExtended(
      {Key key, this.hintText, this.onChanged, this.color, this.validator})
      : super(key: key);
  @override
  _RoundedInputFieldExtendedState createState() =>
      _RoundedInputFieldExtendedState();
}

class _RoundedInputFieldExtendedState extends State<RoundedInputFieldExtended> {
  @override
  Widget build(BuildContext context) {
    return TextFieldContainerExtended(
      child: TextFormField(
        //inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        validator: widget.validator,
        onChanged: widget.onChanged,

        decoration: InputDecoration(
          hintStyle:
              GoogleFonts.montserrat(color: Colors.black54, fontSize: 14),
          hintText: widget.hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class TextFieldContainerExtended extends StatefulWidget {
  final Widget child;
  final Color color;

  const TextFieldContainerExtended({
    Key key,
    this.child,
    this.color: Colors.white,
  }) : super(key: key);

  @override
  _TextFieldContainerExtendedState createState() =>
      _TextFieldContainerExtendedState();
}

class _TextFieldContainerExtendedState
    extends State<TextFieldContainerExtended> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: size.width * 0.9,
      height: size.height * 0.7,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(0.0),
      ),
      child: widget.child,
    );
  }
}

class DecoratedCard extends StatefulWidget {
  final Widget child;
  final Function onTap;
  final Color color;

  const DecoratedCard(
      {Key key,
      @required this.onTap,
      @required this.child,
      this.color = Colors.white})
      : super(key: key);
  @override
  _DecoratedCardState createState() => _DecoratedCardState();
}

class _DecoratedCardState extends State<DecoratedCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Card(
          color: Theme.of(context).primaryColorLight,
          margin: EdgeInsets.only(top: 10.0),
          child: Container(
            child: InkWell(
              splashColor: Theme.of(context).primaryColorDark,
              child: Padding(
                  padding: const EdgeInsets.all(25.0), child: widget.child),
              onTap: widget.onTap,
            ),
          )),
    );
  }
}
