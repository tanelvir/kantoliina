Feature: Invoice members

  I want to see if the invoice functionality works

  Background: Admins, membergroups and members exist in the database

    Given the following admins exist:
      | username | password  | email          |
      | admin    | qwerty123 | testi@testi.fi |

    Given the following membergroups exist:
      | id | name           | fee  | onetimefee |
      | 1  | Ainaisjäsen    | 40.0 | true       |
      | 2  | Varsinaisjäsen | 20.0 | false      |

    Given the following members exist:
      | id | firstnames         | surname    | municipality | address       | zipcode | postoffice | country | email                      | membernumber | membergroup_id | membershipyear | paymentstatus | invoicedate | active |
      | 1  | Maksamatonnormaali | Jäsen      | Vantaa       | Jokiniementie | 54321   | Stadi      | Finland | example@example.com        | 12345        | 2              | 2013           | false         | 2013.01.01  | true   |
      | 2  | Maksanutainais     | Mehiläinen | Espoo        | Jokintie      | 12345   | Stadi      | Finland | liisa.mehilainen@gmail.com | 12466        | 1              | 2013           | true          | 2013.01.01  | true   |
      | 3  | Maksanutnormaali   | Mehiläinen | Espoo        | Jokintie      | 12345   | Stadi      | Finland | liisa.mehilainen@gmail.com | 12467        | 2              | 2013           | true          | 2013.01.01  | true   |
      | 4  | Maksamatonainais   | Mehiläinen | Espoo        | Jokintie      | 12345   | Stadi      | Finland | liisa.mehilainen@gmail.com | 12468        | 1              | 2013           | false         | 2013.01.01  | true   |


    When I am on the login page
    And I fill in "username" with "admin"
    And I fill in "password" with "qwerty123"
    And I press "Login"

  Scenario: Select all members and send an invoice to those applicable
    And I check "check_all"
    And I press "Luo laskut"
    And I should see "Laskunsa jo maksaneita ainaisjäseniä ei otettu listaan"
    And I should not see "Maksanutainais"
    And I should see "Maksamatonnormaali"
    And I should see "Maksanutnormaali"
    And I should see "Maksamatonainais"
    And I press "Lähetä laskut"
    Then I should see "Valitse sarakkeet"
    And I should see "Laskut lähetetty"
    And I should receive an email
    When I open the email with subject "Kantoliinayhdistyksen jäsenmaksulasku"
    Then I should see "Kantoliinayhdistyksen jäsenmaksulasku" in the email subject
    Then I should see "20.0" in the email body

  Scenario: I try to send an invoice to a permanen member who has already paid
    And I check "member_2"
    And I press "Luo laskut"
    And I should see "Laskunsa jo maksaneille ainaisjäsenille ei voi lähettää laskua"

  Scenario: Select all members and remove one in the invoice page
    And I check "check_all"
    And I press "Luo laskut"
    And I should not see "Maksanutainais"
    And I should see "Maksamatonnormaali"
    And I should see "Maksanutnormaali"
    And I should see "Maksamatonainais"
    And I press "member_1"
    Then I should not see "Maksamatonnormaali"

  Scenario: View invoice template in invoice confirmation page
    And I check "check_all"
    And I press "Luo laskut"
    And I should see "Maksamatonnormaali"
    And I should see "Maksanutnormaali"
    And I should see "Maksamatonainais"
    And I press "Esikatsele"
    Then I should see "Kantoliinayhdistyksen jäsenmaksu -lasku"


  Scenario: View invoice template with additional information in invoice confirmation page
    And I check "check_all"
    And I press "Luo laskut"
    And I should see "Maksamatonnormaali"
    And I should see "Maksanutnormaali"
    And I should see "Maksamatonainais"
    And I fill in "top_message" with "Ylä viesti"
    And I fill in "bottom_message" with "Ala viesti"
    And I press "Esikatsele"
    Then I should see "Kantoliinayhdistyksen jäsenmaksu -lasku"
    And I should see "Ala viesti"
    And I should see "Ylä viesti"

  Scenario: Edit topic of the invoice and see the change in mail
    And I check "check_all"
    And I press "Luo laskut"
    And I should see "Maksamatonnormaali"
    And I should see "Maksanutnormaali"
    And I should see "Maksamatonainais"
    And I fill in "top_message" with "Ylä viesti"
    And I fill in "bottom_message" with "Ala viesti"
    And I fill in "subject" with "Otsikko"
    And I press "Lähetä laskut"
    Then I should see "Valitse sarakkeet"
    And I should see "Laskut lähetetty"
    And I should receive an email
    When I open the email with subject "Otsikko"
    Then I should see "Otsikko" in the email subject
    Then I should see "20.0" in the email body