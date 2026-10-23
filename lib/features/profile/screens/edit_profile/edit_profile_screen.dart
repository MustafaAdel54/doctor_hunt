import 'package:doctor_hunt/core/di/injector.dart';
import 'package:doctor_hunt/features/auth/models/user_model.dart';
import 'package:doctor_hunt/features/profile/cubit/profile_cubit.dart';
import 'package:doctor_hunt/features/profile/cubit/profile_state.dart';
import 'package:doctor_hunt/features/profile/screens/edit_profile/widgets/edit_profile_form.dart';
import 'package:doctor_hunt/features/profile/screens/widgets/profile_header.dart';
import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:doctor_hunt/shared/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProfileCubit>()..loadProfile(),
      child: const _EditProfileView(),
    );
  }
}

class _EditProfileView extends StatefulWidget {
  const _EditProfileView();

  @override
  State<_EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<_EditProfileView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _initFields(UserModel user) {
    if (!_initialized) {
      _nameController.text = user.name ?? '';
      _phoneController.text = user.phone ?? '';
      _initialized = true;
    }
  }

  Future<void> _handleSubmit(BuildContext context) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final cubit = context.read<ProfileCubit>();
    if (cubit.isUpdating) return;

    final success = await cubit.updateProfile(
      name: _nameController.text,
      phone: _phoneController.text,
    );

    if (success && context.mounted) {
      context.pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Scaffold(
      backgroundColor: palette.surface,
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdateError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(t.profile.updateError),
                backgroundColor: palette.danger,
              ),
            );
          }
        },
        builder: (context, state) {
          UserModel? user;
          bool isLoading = false;
          bool isSaving = false;

          if (state is ProfileLoading && !_initialized) {
            isLoading = true;
          } else if (state is ProfileLoaded) {
            user = state.user;
            _initFields(user);
          } else if (state is ProfileUpdating) {
            user = state.user;
            isSaving = true;
          } else if (state is ProfileUpdateSuccess) {
            user = state.user;
          } else if (state is ProfileUpdateError) {
            user = state.user;
          } else {
            user = context.read<ProfileCubit>().currentUser;
            if (user != null) _initFields(user);
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ProfileHeader(
                  title: t.profile.editProfile,
                  photoUrl: user?.photoUrl,
                ),

                if (isLoading)
                  Padding(
                    padding: EdgeInsets.only(top: 80.h),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: palette.primary,
                      ),
                    ),
                  )
                else
                  EditProfileForm(
                    formKey: _formKey,
                    nameController: _nameController,
                    phoneController: _phoneController,
                    isSaving: isSaving,
                    onSubmit: () => _handleSubmit(context),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
