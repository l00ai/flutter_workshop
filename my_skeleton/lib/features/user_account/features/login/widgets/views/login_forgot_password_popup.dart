import 'package:flutter/material.dart';
import 'package:my_skeleton/constants/strings/strings.dart';
import 'package:my_skeleton/constants/theme/my_measurements.dart';
import 'package:my_skeleton/features/user_account/features/login/widgets/view_models/login_forgot_password_popup_view_model.dart';
import 'package:my_skeleton/providers/my_auth_provider.dart';
import 'package:my_skeleton/providers/my_string_provider.dart';
import 'package:my_skeleton/utils/my_tools.dart';
import 'package:my_skeleton/widgets/views/my_alert.dart';
import 'package:my_skeleton/widgets/views/my_modal_bottom_sheet_scaffold.dart';
import 'package:my_skeleton/widgets/views/my_text_field.dart';

class LoginForgotPasswordPopup extends StatefulWidget {
  const LoginForgotPasswordPopup({super.key});

  @override
  State<LoginForgotPasswordPopup> createState() =>
      _LoginForgotPasswordPopupState();
}

class _LoginForgotPasswordPopupState extends State<LoginForgotPasswordPopup> {
  _LoginForgotPasswordPopupState() : linkSent = false;

  /// Whether or not the email reset link has been sent to the user.
  bool linkSent;

  @override
  Widget build(BuildContext context) {
    /// All of the strings on this page.
    final Strings strings = MyStringProvider.of(
      context,
      listen: true,
    ).strings;

    final LoginForgotPasswordPopupViewModel viewModel =
        LoginForgotPasswordPopupViewModel(strings);

    return MyModalBottomSheetScaffold(
      title: strings.forgotPassword,
      child: _buildBody(context, viewModel),
    );
  }

  Widget _buildBody(
      BuildContext context, LoginForgotPasswordPopupViewModel viewModel) {
    if (linkSent) {
      return _buildSuccess(context, viewModel);
    } else {
      return _buildForm(viewModel);
    }
  }

  Widget _buildForm(LoginForgotPasswordPopupViewModel viewModel) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // INSTRUCTIONS
        Padding(
          padding: const EdgeInsets.only(
            bottom: MyMeasurements.elementSpread,
          ),
          child: Text(
            "${MyTools.capitalizeFirstLetter(viewModel.strings.resetPasswordInstructions)}.",
          ),
        ),

        // EMAIL text field
        Padding(
          padding: const EdgeInsets.only(
            bottom: MyMeasurements.elementSpread,
          ),
          child: MyTextField(
            key: viewModel.emailFieldKey,
            controller: viewModel.emailController,
            isLastField: true,
            hint: viewModel.strings.email,
            prefixIcon: const Icon(
              Icons.email,
            ),
            validators: viewModel.emailValidators,
          ),
        ),

        // RESET button
        TextButton(
          onPressed: () async {
            FocusScope.of(context).unfocus();
            await viewModel.onReset(MyAuthProvider.of(context)).then((result) {
              if (result > 0) {
                setState(() {
                  linkSent = true;
                });
              } else if (result < 0) {
                MyAlert(
                  title: MyTools.capitalizeFirstLetter(viewModel.strings.error),
                  content:
                      "${MyTools.capitalizeFirstLetter(viewModel.strings.failedPasswordReset)}! "
                      "${MyTools.capitalizeFirstLetter(viewModel.strings.tryAgainLater)}.",
                  buttons: {viewModel.strings.ok: () {}},
                ).show(context);
              }
            });
          },
          child: Text(MyTools.capitalizeEachWord(viewModel.strings.reset)),
        ),
      ],
    );
  }

  Widget _buildSuccess(
      BuildContext context, LoginForgotPasswordPopupViewModel viewModel) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // SUCCESS icon
          Padding(
            padding: const EdgeInsets.only(
              bottom: MyMeasurements.elementSpread,
            ),
            child: Icon(
              Icons.check_circle_outline,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),

          // Success text
          Padding(
            padding: const EdgeInsets.only(
              bottom: MyMeasurements.elementSpread,
            ),
            child: Text(
              "${MyTools.capitalizeFirstLetter(viewModel.strings.passwordResetLinkSent)}!",
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }
}
