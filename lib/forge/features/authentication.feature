Feature: User creation
  As a user of the site
  I should not be able to register for an account

@allow-rescue
Scenario: Trying to create an account
  Given I am on '/register'
  Then I should see an error