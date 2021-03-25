<?php

namespace Drupal\my_custom_module\Form;

use Drupal\my_custom_module\traits\Environment;

use Drupal\Core\Form\FormBase;
use Drupal\Core\Form\FormStateInterface;

/**
 * The custom asdmin settings form our site.
 */
class AdminSettingsForm extends FormBase {

  use Environment;

  /**
   * {@inheritdoc}
   */
  public function getFormId() {
    return 'app_admin_settings';
  }

  /**
   * {@inheritdoc}
   */
  public function buildForm(array $form, FormStateInterface $form_state) {
    $form = [];
    $form['basic'] = [
      '#type' => 'details',
      '#title' => $this->t('Basic site settings'),
      '#description' => $this->t('Information about the environment.'),
      '#open' => FALSE,
    ];
    $form['basic']['my-information'] = [
      '#type' => 'textfield',
      '#title' => $this->t('Placeholder'),
      '#description' => $this->t('Placeholder.'),
      '#default_value' => $this->stateGet('my-information', 'Default string'),
    ];
    $form['actions']['#type'] = 'actions';
    $form['actions']['submit'] = [
      '#type' => 'submit',
      '#value' => $this->t('Save'),
      '#button_type' => 'primary',
    ];
    return $form;
  }

  /**
   * {@inheritdoc}
   */
  public function submitForm(array &$form, FormStateInterface $form_state) {
    $input = $this->formStateGetUserInput($form_state);
    $this->stateSet('my-information', $input['my-information']);
    $this->drupalSetMessage($this->t('Settings saved successfully.'));
  }

}
