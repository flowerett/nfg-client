module NFGClient
  class PaypalClient < BaseClient
    def initialize(partner_id, partner_password, partner_source, partner_campaign, use_sandbox = true)
      super({
        partner_id: partner_id,
        partner_password: partner_password,
        partner_source: partner_source,
        partner_campaign: partner_campaign,
        use_sandbox: use_sandbox
      })
      @nfg_urls = {
        'sandbox' => {
          'host' => 'api-sandbox.networkforgood.org',
          'url' => 'https://api-sandbox.networkforgood.org/PartnerDonationService/PayPal.asmx',
          'wsdl' => 'https://api-sandbox.networkforgood.org/PartnerDonationService/PayPal.asmx?wsdl'
        },
        'production' => {
          'host' => 'api.networkforgood.org',
          'url' => 'https://api.networkforgood.org/PartnerDonationService/PayPal.asmx',
          'wsdl' => 'https://api.networkforgood.org/PartnerDonationService/PayPal.asmx?wsdl'
        }
      }
    end

    # Initialize PayPal Checkout
    #
    # Arguments:
    #   params: (Hash)
    def initialize_paypal_checkout(params)
      requires!(params, :DonationLineItems, :DonorIpAddress, :DonorToken, :DisplayName, :TipAmount, :ReturnURL, :CancelURL)
      call_params = add_credentials_to_params(params)
      response = nfg_soap_request('InitializePayPalCheckout', call_params)
      if response.is_a? REXML::Element
        if (response.elements['StatusCode'].get_text.to_s == 'Success')
          {
            'StatusCode' => response.elements['StatusCode'].get_text.to_s,
            'Message' => response.elements['Message'].get_text.to_s,
            'ErrorDetails' => response.elements['ErrorDetails'].get_text.to_s,
            'CallDuration' => response.elements['CallDuration'].get_text.to_s,
            'RedirectURL' => response.elements['RedirectURL'].get_text.to_s,
            'PPToken' => response.elements['PPToken'].get_text.to_s,
          }
        else
          response_hash = {
            'StatusCode' => response.elements['StatusCode'].get_text.to_s,
            'Message' => response.elements['Message'].get_text.to_s,
            'CallDuration' => response.elements['CallDuration'].get_text.to_s,
          }
          if response.elements['ErrorDetails']
            response_hash['ErrorDetails'] = {}
            if response.elements['ErrorDetails/ErrorInfo']
              response_hash['ErrorInfo'] = {}
              response_hash['ErrCode'] = response.elements['ErrorDetails/ErrorInfo/ErrCode'].get_text.to_s if response.elements['ErrorDetails/ErrorInfo/ErrCode']
              response_hash['ErrCode'] = response.elements['ErrorDetails/ErrorInfo/ErrCode'].get_text.to_s if response.elements['ErrorDetails/ErrorInfo/ErrCode']
            end
          end
          response_hash
        end
      else
        response
      end
    end

    # Complete PayPal Checkout
    #
    # Arguments:
    #   params: (Hash)
    def complete_paypal_checkout(params)
      requires!(params, :PPToken)
      call_params = add_credentials_to_params(params)
      response = nfg_soap_request('CompletePayPalCheckout', call_params)
      if response.is_a? REXML::Element
        if (response.elements['StatusCode'].get_text.to_s == 'Success')
          {
            'StatusCode' => response.elements['StatusCode'].get_text.to_s,
            'Message' => response.elements['Message'].get_text.to_s,
            'ErrorDetails' => response.elements['ErrorDetails'].get_text.to_s,
            'CallDuration' => response.elements['CallDuration'].get_text.to_s,
            'DonorEmail' => response.elements['DonorEmail'].get_text.to_s,
            'DonorFirstName' => response.elements['DonorFirstName'].get_text.to_s,
            'DonorLastName' => response.elements['DonorLastName'].get_text.to_s,
            'DonorAddress1' => response.elements['DonorAddress1'].get_text.to_s,
            'DonorAddress2' => response.elements['DonorAddress2'].get_text.to_s,
            'DonorCity' => response.elements['DonorCity'].get_text.to_s,
            'DonorState' => response.elements['DonorState'].get_text.to_s,
            'DonorZip' => response.elements['DonorZip'].get_text.to_s,
            'DonorCountry' => response.elements['DonorCountry'].get_text.to_s,
            'DonorPhone' => response.elements['DonorPhone'].get_text.to_s,
            'ChargeId' => response.elements['ChargeId'].get_text.to_s
          }
        else
          response_hash = {
            'StatusCode' => response.elements['StatusCode'].get_text.to_s,
            'Message' => response.elements['Message'].get_text.to_s,
            'CallDuration' => response.elements['CallDuration'].get_text.to_s,
          }
          if response.elements['ErrorDetails']
            response_hash['ErrorDetails'] = {}
            if response.elements['ErrorDetails/ErrorInfo']
              response_hash['ErrorInfo'] = {}
              response_hash['ErrCode'] = response.elements['ErrorDetails/ErrorInfo/ErrCode'].get_text.to_s if response.elements['ErrorDetails/ErrorInfo/ErrCode']
              response_hash['ErrCode'] = response.elements['ErrorDetails/ErrorInfo/ErrCode'].get_text.to_s if response.elements['ErrorDetails/ErrorInfo/ErrCode']
            end
          end
          response_hash
        end
      else
        response
      end
    end

    # Get info about PayPal transaction
    #
    # Arguments:
    #   params: (Hash)
    def get_paypal_checkout_details(params)
      requires!(params, :PPToken)
      call_params = add_credentials_to_params(params)
      response = nfg_soap_request('GetPayPalCheckoutDetails', call_params)
      if response.is_a? REXML::Element
        if (response.elements['StatusCode'].get_text.to_s == 'Success')
          {
            'StatusCode' => response.elements['StatusCode'].get_text.to_s,
            'Message' => response.elements['Message'].get_text.to_s,
            'ErrorDetails' => response.elements['ErrorDetails'].get_text.to_s,
            'CallDuration' => response.elements['CallDuration'].get_text.to_s,
            'DonorEmail' => response.elements['DonorEmail'].get_text.to_s,
            'DonorFirstName' => response.elements['DonorFirstName'].get_text.to_s,
            'DonorLastName' => response.elements['DonorLastName'].get_text.to_s,
            'DonorAddress1' => response.elements['DonorAddress1'].get_text.to_s,
            'DonorAddress2' => response.elements['DonorAddress2'].get_text.to_s,
            'DonorCity' => response.elements['DonorCity'].get_text.to_s,
            'DonorState' => response.elements['DonorState'].get_text.to_s,
            'DonorZip' => response.elements['DonorZip'].get_text.to_s,
            'DonorCountry' => response.elements['DonorCountry'].get_text.to_s,
            'DonorPhone' => response.elements['DonorPhone'].get_text.to_s
          }
        else
          response_hash = {
            'StatusCode' => response.elements['StatusCode'].get_text.to_s,
            'Message' => response.elements['Message'].get_text.to_s,
            'CallDuration' => response.elements['CallDuration'].get_text.to_s,
          }
          if response.elements['ErrorDetails']
            response_hash['ErrorDetails'] = {}
            if response.elements['ErrorDetails/ErrorInfo']
              response_hash['ErrorInfo'] = {}
              response_hash['ErrCode'] = response.elements['ErrorDetails/ErrorInfo/ErrCode'].get_text.to_s if response.elements['ErrorDetails/ErrorInfo/ErrCode']
              response_hash['ErrCode'] = response.elements['ErrorDetails/ErrorInfo/ErrCode'].get_text.to_s if response.elements['ErrorDetails/ErrorInfo/ErrCode']
            end
          end
          response_hash
        end
      else
        response
      end
    end
  end
end