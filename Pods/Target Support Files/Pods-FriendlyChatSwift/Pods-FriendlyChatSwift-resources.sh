#!/bin/sh
set -e

mkdir -p "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"

RESOURCES_TO_COPY=${PODS_ROOT}/resources-to-copy-${TARGETNAME}.txt
> "$RESOURCES_TO_COPY"

XCASSET_FILES=()

case "${TARGETED_DEVICE_FAMILY}" in
  1,2)
    TARGET_DEVICE_ARGS="--target-device ipad --target-device iphone"
    ;;
  1)
    TARGET_DEVICE_ARGS="--target-device iphone"
    ;;
  2)
    TARGET_DEVICE_ARGS="--target-device ipad"
    ;;
  3)
    TARGET_DEVICE_ARGS="--target-device tv"
    ;;
  *)
    TARGET_DEVICE_ARGS="--target-device mac"
    ;;
esac

install_resource()
{
  if [[ "$1" = /* ]] ; then
    RESOURCE_PATH="$1"
  else
    RESOURCE_PATH="${PODS_ROOT}/$1"
  fi
  if [[ ! -e "$RESOURCE_PATH" ]] ; then
    cat << EOM
error: Resource "$RESOURCE_PATH" not found. Run 'pod install' to update the copy resources script.
EOM
    exit 1
  fi
  case $RESOURCE_PATH in
    *.storyboard)
      echo "ibtool --reference-external-strings-file --errors --warnings --notices --minimum-deployment-target ${!DEPLOYMENT_TARGET_SETTING_NAME} --output-format human-readable-text --compile ${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$RESOURCE_PATH\" .storyboard`.storyboardc $RESOURCE_PATH --sdk ${SDKROOT} ${TARGET_DEVICE_ARGS}"
      ibtool --reference-external-strings-file --errors --warnings --notices --minimum-deployment-target ${!DEPLOYMENT_TARGET_SETTING_NAME} --output-format human-readable-text --compile "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$RESOURCE_PATH\" .storyboard`.storyboardc" "$RESOURCE_PATH" --sdk "${SDKROOT}" ${TARGET_DEVICE_ARGS}
      ;;
    *.xib)
      echo "ibtool --reference-external-strings-file --errors --warnings --notices --minimum-deployment-target ${!DEPLOYMENT_TARGET_SETTING_NAME} --output-format human-readable-text --compile ${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$RESOURCE_PATH\" .xib`.nib $RESOURCE_PATH --sdk ${SDKROOT} ${TARGET_DEVICE_ARGS}"
      ibtool --reference-external-strings-file --errors --warnings --notices --minimum-deployment-target ${!DEPLOYMENT_TARGET_SETTING_NAME} --output-format human-readable-text --compile "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$RESOURCE_PATH\" .xib`.nib" "$RESOURCE_PATH" --sdk "${SDKROOT}" ${TARGET_DEVICE_ARGS}
      ;;
    *.framework)
      echo "mkdir -p ${TARGET_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      mkdir -p "${TARGET_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      echo "rsync -av $RESOURCE_PATH ${TARGET_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      rsync -av "$RESOURCE_PATH" "${TARGET_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      ;;
    *.xcdatamodel)
      echo "xcrun momc \"$RESOURCE_PATH\" \"${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH"`.mom\""
      xcrun momc "$RESOURCE_PATH" "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH" .xcdatamodel`.mom"
      ;;
    *.xcdatamodeld)
      echo "xcrun momc \"$RESOURCE_PATH\" \"${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH" .xcdatamodeld`.momd\""
      xcrun momc "$RESOURCE_PATH" "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH" .xcdatamodeld`.momd"
      ;;
    *.xcmappingmodel)
      echo "xcrun mapc \"$RESOURCE_PATH\" \"${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH" .xcmappingmodel`.cdm\""
      xcrun mapc "$RESOURCE_PATH" "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH" .xcmappingmodel`.cdm"
      ;;
    *.xcassets)
      ABSOLUTE_XCASSET_FILE="$RESOURCE_PATH"
      XCASSET_FILES+=("$ABSOLUTE_XCASSET_FILE")
      ;;
    *)
      echo "$RESOURCE_PATH"
      echo "$RESOURCE_PATH" >> "$RESOURCES_TO_COPY"
      ;;
  esac
}
if [[ "$CONFIGURATION" == "Debug" ]]; then
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/FUIAccountSettingsViewController.nib"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/FUIAuthPickerViewController.nib"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/FUIAuthTableViewCell.nib"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/FUIEmailEntryViewController.nib"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/FUIInputTableViewCell.nib"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/FUIPasswordRecoveryViewController.nib"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/FUIPasswordSignInViewController.nib"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/FUIPasswordSignUpViewController.nib"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/FUIPasswordTableViewCell.nib"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/FUIPasswordVerificationViewController.nib"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/FUIStaticContentTableViewController.nib"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/ic_email.png"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/ic_email@2x.png"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/ic_email@3x.png"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/ic_visibility.png"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/ic_visibility@2x.png"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/ic_visibility@3x.png"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/ic_visibility_off.png"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/ic_visibility_off@2x.png"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/ic_visibility_off@3x.png"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/ar.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/de.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/en-GB.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/en.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/es-419.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/es-ES.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/fr.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/it.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/ja.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/ko.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/nl.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/pl.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/pt-BR.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/ru.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/th.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/tr.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/zh-Hans.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/zh-Hant.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseFacebookAuthUI/Frameworks/FirebaseFacebookAuthUI.framework/ic_facebook.png"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseFacebookAuthUI/Frameworks/FirebaseFacebookAuthUI.framework/ic_facebook@2x.png"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseFacebookAuthUI/Frameworks/FirebaseFacebookAuthUI.framework/ic_facebook@3x.png"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseFacebookAuthUI/Frameworks/FirebaseFacebookAuthUI.framework/ar.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseFacebookAuthUI/Frameworks/FirebaseFacebookAuthUI.framework/de.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseFacebookAuthUI/Frameworks/FirebaseFacebookAuthUI.framework/en-GB.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseFacebookAuthUI/Frameworks/FirebaseFacebookAuthUI.framework/en.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseFacebookAuthUI/Frameworks/FirebaseFacebookAuthUI.framework/es-419.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseFacebookAuthUI/Frameworks/FirebaseFacebookAuthUI.framework/es-ES.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseFacebookAuthUI/Frameworks/FirebaseFacebookAuthUI.framework/fr.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseFacebookAuthUI/Frameworks/FirebaseFacebookAuthUI.framework/it.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseFacebookAuthUI/Frameworks/FirebaseFacebookAuthUI.framework/ja.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseFacebookAuthUI/Frameworks/FirebaseFacebookAuthUI.framework/ko.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseFacebookAuthUI/Frameworks/FirebaseFacebookAuthUI.framework/nl.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseFacebookAuthUI/Frameworks/FirebaseFacebookAuthUI.framework/pl.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseFacebookAuthUI/Frameworks/FirebaseFacebookAuthUI.framework/pt-BR.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseFacebookAuthUI/Frameworks/FirebaseFacebookAuthUI.framework/ru.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseFacebookAuthUI/Frameworks/FirebaseFacebookAuthUI.framework/th.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseFacebookAuthUI/Frameworks/FirebaseFacebookAuthUI.framework/tr.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseFacebookAuthUI/Frameworks/FirebaseFacebookAuthUI.framework/zh-Hans.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseFacebookAuthUI/Frameworks/FirebaseFacebookAuthUI.framework/zh-Hant.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseGoogleAuthUI/Frameworks/FirebaseGoogleAuthUI.framework/ic_google.png"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseGoogleAuthUI/Frameworks/FirebaseGoogleAuthUI.framework/ic_google@2x.png"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseGoogleAuthUI/Frameworks/FirebaseGoogleAuthUI.framework/ic_google@3x.png"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseGoogleAuthUI/Frameworks/FirebaseGoogleAuthUI.framework/ar.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseGoogleAuthUI/Frameworks/FirebaseGoogleAuthUI.framework/de.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseGoogleAuthUI/Frameworks/FirebaseGoogleAuthUI.framework/en-GB.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseGoogleAuthUI/Frameworks/FirebaseGoogleAuthUI.framework/en.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseGoogleAuthUI/Frameworks/FirebaseGoogleAuthUI.framework/es-419.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseGoogleAuthUI/Frameworks/FirebaseGoogleAuthUI.framework/es-ES.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseGoogleAuthUI/Frameworks/FirebaseGoogleAuthUI.framework/fr.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseGoogleAuthUI/Frameworks/FirebaseGoogleAuthUI.framework/it.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseGoogleAuthUI/Frameworks/FirebaseGoogleAuthUI.framework/ja.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseGoogleAuthUI/Frameworks/FirebaseGoogleAuthUI.framework/ko.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseGoogleAuthUI/Frameworks/FirebaseGoogleAuthUI.framework/nl.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseGoogleAuthUI/Frameworks/FirebaseGoogleAuthUI.framework/pl.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseGoogleAuthUI/Frameworks/FirebaseGoogleAuthUI.framework/pt-BR.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseGoogleAuthUI/Frameworks/FirebaseGoogleAuthUI.framework/ru.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseGoogleAuthUI/Frameworks/FirebaseGoogleAuthUI.framework/th.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseGoogleAuthUI/Frameworks/FirebaseGoogleAuthUI.framework/tr.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseGoogleAuthUI/Frameworks/FirebaseGoogleAuthUI.framework/zh-Hans.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseGoogleAuthUI/Frameworks/FirebaseGoogleAuthUI.framework/zh-Hant.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebasePhoneAuthUI/Frameworks/FirebasePhoneAuthUI.framework/country-codes.json"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebasePhoneAuthUI/Frameworks/FirebasePhoneAuthUI.framework/FUICodeField.nib"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebasePhoneAuthUI/Frameworks/FirebasePhoneAuthUI.framework/FUICountryTableViewController.nib"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebasePhoneAuthUI/Frameworks/FirebasePhoneAuthUI.framework/FUIPhoneEntryViewController.nib"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebasePhoneAuthUI/Frameworks/FirebasePhoneAuthUI.framework/FUIPhoneVerificationViewController.nib"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebasePhoneAuthUI/Frameworks/FirebasePhoneAuthUI.framework/ic_phone.png"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebasePhoneAuthUI/Frameworks/FirebasePhoneAuthUI.framework/ic_phone@2x.png"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebasePhoneAuthUI/Frameworks/FirebasePhoneAuthUI.framework/ic_phone@3x.png"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebasePhoneAuthUI/Frameworks/FirebasePhoneAuthUI.framework/ar.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebasePhoneAuthUI/Frameworks/FirebasePhoneAuthUI.framework/de.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebasePhoneAuthUI/Frameworks/FirebasePhoneAuthUI.framework/en-GB.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebasePhoneAuthUI/Frameworks/FirebasePhoneAuthUI.framework/en.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebasePhoneAuthUI/Frameworks/FirebasePhoneAuthUI.framework/es-419.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebasePhoneAuthUI/Frameworks/FirebasePhoneAuthUI.framework/es-ES.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebasePhoneAuthUI/Frameworks/FirebasePhoneAuthUI.framework/fr.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebasePhoneAuthUI/Frameworks/FirebasePhoneAuthUI.framework/it.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebasePhoneAuthUI/Frameworks/FirebasePhoneAuthUI.framework/ja.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebasePhoneAuthUI/Frameworks/FirebasePhoneAuthUI.framework/ko.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebasePhoneAuthUI/Frameworks/FirebasePhoneAuthUI.framework/nl.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebasePhoneAuthUI/Frameworks/FirebasePhoneAuthUI.framework/pl.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebasePhoneAuthUI/Frameworks/FirebasePhoneAuthUI.framework/pt-BR.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebasePhoneAuthUI/Frameworks/FirebasePhoneAuthUI.framework/ru.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebasePhoneAuthUI/Frameworks/FirebasePhoneAuthUI.framework/th.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebasePhoneAuthUI/Frameworks/FirebasePhoneAuthUI.framework/tr.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebasePhoneAuthUI/Frameworks/FirebasePhoneAuthUI.framework/zh-Hans.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebasePhoneAuthUI/Frameworks/FirebasePhoneAuthUI.framework/zh-Hant.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseTwitterAuthUI/Frameworks/FirebaseTwitterAuthUI.framework/ic_twitter.png"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseTwitterAuthUI/Frameworks/FirebaseTwitterAuthUI.framework/ic_twitter@2x.png"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseTwitterAuthUI/Frameworks/FirebaseTwitterAuthUI.framework/ic_twitter@3x.png"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseTwitterAuthUI/Frameworks/FirebaseTwitterAuthUI.framework/ar.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseTwitterAuthUI/Frameworks/FirebaseTwitterAuthUI.framework/de.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseTwitterAuthUI/Frameworks/FirebaseTwitterAuthUI.framework/en-GB.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseTwitterAuthUI/Frameworks/FirebaseTwitterAuthUI.framework/en.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseTwitterAuthUI/Frameworks/FirebaseTwitterAuthUI.framework/es-419.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseTwitterAuthUI/Frameworks/FirebaseTwitterAuthUI.framework/es-ES.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseTwitterAuthUI/Frameworks/FirebaseTwitterAuthUI.framework/fr.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseTwitterAuthUI/Frameworks/FirebaseTwitterAuthUI.framework/it.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseTwitterAuthUI/Frameworks/FirebaseTwitterAuthUI.framework/ja.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseTwitterAuthUI/Frameworks/FirebaseTwitterAuthUI.framework/ko.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseTwitterAuthUI/Frameworks/FirebaseTwitterAuthUI.framework/nl.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseTwitterAuthUI/Frameworks/FirebaseTwitterAuthUI.framework/pl.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseTwitterAuthUI/Frameworks/FirebaseTwitterAuthUI.framework/pt-BR.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseTwitterAuthUI/Frameworks/FirebaseTwitterAuthUI.framework/ru.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseTwitterAuthUI/Frameworks/FirebaseTwitterAuthUI.framework/th.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseTwitterAuthUI/Frameworks/FirebaseTwitterAuthUI.framework/tr.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseTwitterAuthUI/Frameworks/FirebaseTwitterAuthUI.framework/zh-Hans.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseTwitterAuthUI/Frameworks/FirebaseTwitterAuthUI.framework/zh-Hant.lproj"
  install_resource "GoogleSignIn/Resources/GoogleSignIn.bundle"
  install_resource "TwitterKit/iOS/TwitterKit.framework/Versions/A/Resources/TwitterKitResources.bundle"
fi
if [[ "$CONFIGURATION" == "Release" ]]; then
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/FUIAccountSettingsViewController.nib"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/FUIAuthPickerViewController.nib"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/FUIAuthTableViewCell.nib"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/FUIEmailEntryViewController.nib"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/FUIInputTableViewCell.nib"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/FUIPasswordRecoveryViewController.nib"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/FUIPasswordSignInViewController.nib"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/FUIPasswordSignUpViewController.nib"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/FUIPasswordTableViewCell.nib"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/FUIPasswordVerificationViewController.nib"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/FUIStaticContentTableViewController.nib"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/ic_email.png"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/ic_email@2x.png"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/ic_email@3x.png"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/ic_visibility.png"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/ic_visibility@2x.png"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/ic_visibility@3x.png"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/ic_visibility_off.png"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/ic_visibility_off@2x.png"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/ic_visibility_off@3x.png"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/ar.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/de.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/en-GB.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/en.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/es-419.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/es-ES.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/fr.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/it.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/ja.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/ko.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/nl.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/pl.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/pt-BR.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/ru.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/th.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/tr.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/zh-Hans.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseAuthUI/Frameworks/FirebaseAuthUI.framework/zh-Hant.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseFacebookAuthUI/Frameworks/FirebaseFacebookAuthUI.framework/ic_facebook.png"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseFacebookAuthUI/Frameworks/FirebaseFacebookAuthUI.framework/ic_facebook@2x.png"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseFacebookAuthUI/Frameworks/FirebaseFacebookAuthUI.framework/ic_facebook@3x.png"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseFacebookAuthUI/Frameworks/FirebaseFacebookAuthUI.framework/ar.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseFacebookAuthUI/Frameworks/FirebaseFacebookAuthUI.framework/de.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseFacebookAuthUI/Frameworks/FirebaseFacebookAuthUI.framework/en-GB.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseFacebookAuthUI/Frameworks/FirebaseFacebookAuthUI.framework/en.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseFacebookAuthUI/Frameworks/FirebaseFacebookAuthUI.framework/es-419.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseFacebookAuthUI/Frameworks/FirebaseFacebookAuthUI.framework/es-ES.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseFacebookAuthUI/Frameworks/FirebaseFacebookAuthUI.framework/fr.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseFacebookAuthUI/Frameworks/FirebaseFacebookAuthUI.framework/it.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseFacebookAuthUI/Frameworks/FirebaseFacebookAuthUI.framework/ja.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseFacebookAuthUI/Frameworks/FirebaseFacebookAuthUI.framework/ko.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseFacebookAuthUI/Frameworks/FirebaseFacebookAuthUI.framework/nl.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseFacebookAuthUI/Frameworks/FirebaseFacebookAuthUI.framework/pl.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseFacebookAuthUI/Frameworks/FirebaseFacebookAuthUI.framework/pt-BR.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseFacebookAuthUI/Frameworks/FirebaseFacebookAuthUI.framework/ru.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseFacebookAuthUI/Frameworks/FirebaseFacebookAuthUI.framework/th.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseFacebookAuthUI/Frameworks/FirebaseFacebookAuthUI.framework/tr.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseFacebookAuthUI/Frameworks/FirebaseFacebookAuthUI.framework/zh-Hans.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseFacebookAuthUI/Frameworks/FirebaseFacebookAuthUI.framework/zh-Hant.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseGoogleAuthUI/Frameworks/FirebaseGoogleAuthUI.framework/ic_google.png"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseGoogleAuthUI/Frameworks/FirebaseGoogleAuthUI.framework/ic_google@2x.png"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseGoogleAuthUI/Frameworks/FirebaseGoogleAuthUI.framework/ic_google@3x.png"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseGoogleAuthUI/Frameworks/FirebaseGoogleAuthUI.framework/ar.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseGoogleAuthUI/Frameworks/FirebaseGoogleAuthUI.framework/de.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseGoogleAuthUI/Frameworks/FirebaseGoogleAuthUI.framework/en-GB.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseGoogleAuthUI/Frameworks/FirebaseGoogleAuthUI.framework/en.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseGoogleAuthUI/Frameworks/FirebaseGoogleAuthUI.framework/es-419.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseGoogleAuthUI/Frameworks/FirebaseGoogleAuthUI.framework/es-ES.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseGoogleAuthUI/Frameworks/FirebaseGoogleAuthUI.framework/fr.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseGoogleAuthUI/Frameworks/FirebaseGoogleAuthUI.framework/it.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseGoogleAuthUI/Frameworks/FirebaseGoogleAuthUI.framework/ja.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseGoogleAuthUI/Frameworks/FirebaseGoogleAuthUI.framework/ko.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseGoogleAuthUI/Frameworks/FirebaseGoogleAuthUI.framework/nl.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseGoogleAuthUI/Frameworks/FirebaseGoogleAuthUI.framework/pl.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseGoogleAuthUI/Frameworks/FirebaseGoogleAuthUI.framework/pt-BR.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseGoogleAuthUI/Frameworks/FirebaseGoogleAuthUI.framework/ru.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseGoogleAuthUI/Frameworks/FirebaseGoogleAuthUI.framework/th.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseGoogleAuthUI/Frameworks/FirebaseGoogleAuthUI.framework/tr.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseGoogleAuthUI/Frameworks/FirebaseGoogleAuthUI.framework/zh-Hans.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseGoogleAuthUI/Frameworks/FirebaseGoogleAuthUI.framework/zh-Hant.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebasePhoneAuthUI/Frameworks/FirebasePhoneAuthUI.framework/country-codes.json"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebasePhoneAuthUI/Frameworks/FirebasePhoneAuthUI.framework/FUICodeField.nib"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebasePhoneAuthUI/Frameworks/FirebasePhoneAuthUI.framework/FUICountryTableViewController.nib"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebasePhoneAuthUI/Frameworks/FirebasePhoneAuthUI.framework/FUIPhoneEntryViewController.nib"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebasePhoneAuthUI/Frameworks/FirebasePhoneAuthUI.framework/FUIPhoneVerificationViewController.nib"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebasePhoneAuthUI/Frameworks/FirebasePhoneAuthUI.framework/ic_phone.png"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebasePhoneAuthUI/Frameworks/FirebasePhoneAuthUI.framework/ic_phone@2x.png"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebasePhoneAuthUI/Frameworks/FirebasePhoneAuthUI.framework/ic_phone@3x.png"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebasePhoneAuthUI/Frameworks/FirebasePhoneAuthUI.framework/ar.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebasePhoneAuthUI/Frameworks/FirebasePhoneAuthUI.framework/de.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebasePhoneAuthUI/Frameworks/FirebasePhoneAuthUI.framework/en-GB.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebasePhoneAuthUI/Frameworks/FirebasePhoneAuthUI.framework/en.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebasePhoneAuthUI/Frameworks/FirebasePhoneAuthUI.framework/es-419.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebasePhoneAuthUI/Frameworks/FirebasePhoneAuthUI.framework/es-ES.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebasePhoneAuthUI/Frameworks/FirebasePhoneAuthUI.framework/fr.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebasePhoneAuthUI/Frameworks/FirebasePhoneAuthUI.framework/it.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebasePhoneAuthUI/Frameworks/FirebasePhoneAuthUI.framework/ja.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebasePhoneAuthUI/Frameworks/FirebasePhoneAuthUI.framework/ko.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebasePhoneAuthUI/Frameworks/FirebasePhoneAuthUI.framework/nl.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebasePhoneAuthUI/Frameworks/FirebasePhoneAuthUI.framework/pl.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebasePhoneAuthUI/Frameworks/FirebasePhoneAuthUI.framework/pt-BR.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebasePhoneAuthUI/Frameworks/FirebasePhoneAuthUI.framework/ru.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebasePhoneAuthUI/Frameworks/FirebasePhoneAuthUI.framework/th.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebasePhoneAuthUI/Frameworks/FirebasePhoneAuthUI.framework/tr.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebasePhoneAuthUI/Frameworks/FirebasePhoneAuthUI.framework/zh-Hans.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebasePhoneAuthUI/Frameworks/FirebasePhoneAuthUI.framework/zh-Hant.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseTwitterAuthUI/Frameworks/FirebaseTwitterAuthUI.framework/ic_twitter.png"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseTwitterAuthUI/Frameworks/FirebaseTwitterAuthUI.framework/ic_twitter@2x.png"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseTwitterAuthUI/Frameworks/FirebaseTwitterAuthUI.framework/ic_twitter@3x.png"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseTwitterAuthUI/Frameworks/FirebaseTwitterAuthUI.framework/ar.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseTwitterAuthUI/Frameworks/FirebaseTwitterAuthUI.framework/de.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseTwitterAuthUI/Frameworks/FirebaseTwitterAuthUI.framework/en-GB.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseTwitterAuthUI/Frameworks/FirebaseTwitterAuthUI.framework/en.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseTwitterAuthUI/Frameworks/FirebaseTwitterAuthUI.framework/es-419.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseTwitterAuthUI/Frameworks/FirebaseTwitterAuthUI.framework/es-ES.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseTwitterAuthUI/Frameworks/FirebaseTwitterAuthUI.framework/fr.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseTwitterAuthUI/Frameworks/FirebaseTwitterAuthUI.framework/it.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseTwitterAuthUI/Frameworks/FirebaseTwitterAuthUI.framework/ja.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseTwitterAuthUI/Frameworks/FirebaseTwitterAuthUI.framework/ko.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseTwitterAuthUI/Frameworks/FirebaseTwitterAuthUI.framework/nl.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseTwitterAuthUI/Frameworks/FirebaseTwitterAuthUI.framework/pl.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseTwitterAuthUI/Frameworks/FirebaseTwitterAuthUI.framework/pt-BR.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseTwitterAuthUI/Frameworks/FirebaseTwitterAuthUI.framework/ru.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseTwitterAuthUI/Frameworks/FirebaseTwitterAuthUI.framework/th.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseTwitterAuthUI/Frameworks/FirebaseTwitterAuthUI.framework/tr.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseTwitterAuthUI/Frameworks/FirebaseTwitterAuthUI.framework/zh-Hans.lproj"
  install_resource "FirebaseUI/FirebaseUIFrameworks/FirebaseTwitterAuthUI/Frameworks/FirebaseTwitterAuthUI.framework/zh-Hant.lproj"
  install_resource "GoogleSignIn/Resources/GoogleSignIn.bundle"
  install_resource "TwitterKit/iOS/TwitterKit.framework/Versions/A/Resources/TwitterKitResources.bundle"
fi

mkdir -p "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
rsync -avr --copy-links --no-relative --exclude '*/.svn/*' --files-from="$RESOURCES_TO_COPY" / "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
if [[ "${ACTION}" == "install" ]] && [[ "${SKIP_INSTALL}" == "NO" ]]; then
  mkdir -p "${INSTALL_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
  rsync -avr --copy-links --no-relative --exclude '*/.svn/*' --files-from="$RESOURCES_TO_COPY" / "${INSTALL_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
fi
rm -f "$RESOURCES_TO_COPY"

if [[ -n "${WRAPPER_EXTENSION}" ]] && [ "`xcrun --find actool`" ] && [ -n "$XCASSET_FILES" ]
then
  # Find all other xcassets (this unfortunately includes those of path pods and other targets).
  OTHER_XCASSETS=$(find "$PWD" -iname "*.xcassets" -type d)
  while read line; do
    if [[ $line != "${PODS_ROOT}*" ]]; then
      XCASSET_FILES+=("$line")
    fi
  done <<<"$OTHER_XCASSETS"

  printf "%s\0" "${XCASSET_FILES[@]}" | xargs -0 xcrun actool --output-format human-readable-text --notices --warnings --platform "${PLATFORM_NAME}" --minimum-deployment-target "${!DEPLOYMENT_TARGET_SETTING_NAME}" ${TARGET_DEVICE_ARGS} --compress-pngs --compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
fi
