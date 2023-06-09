require 'rails_helper'

RSpec.describe 'Admin Invoice Show Page' do
  before (:each) do
    test_data
    stub_request(:get, "https://api.unsplash.com/photos/random?client_id=FlgsxiCZm-o34965PDOwh6xVsDINZFbzSwcz0__LKZQ&query=merchant")
      .to_return(status: 200, body: File.read('./spec/fixtures/merchant.json'))
    stub_request(:get, "https://api.unsplash.com/photos/5Fxuo7x-eyg?client_id=aOXB56mTdUD88zHCvISJODxwbTPyRRsOk0rA8Ha-cbc")
      .to_return(status: 200, body: File.read('./spec/fixtures/app_logo.json'))
  end

  describe 'User Story 32' do 
    it 'can visit the admin invoice show page' do
      visit admin_invoice_path(@invoice_1)
    end

    it 'I see information related to that invoice(invoice id, status, invoice created_at, and customer name)' do
      visit admin_invoice_path(@invoice_1)

      within("#invoice_details") do
        expect(page).to have_content(@invoice_1.id)
        expect(page).to have_content(@invoice_1.status)
        expect(page).to have_content(@invoice_1.created_at.strftime("%A, %B %d, %Y"))
        expect(page).to have_content(@customer_1.first_name)
        expect(page).to have_content(@customer_1.last_name)
      end 

      visit admin_invoice_path(@invoice_2)

      within("#invoice_details") do
        expect(page).to have_content(@invoice_2.id)
        expect(page).to have_content(@invoice_2.status)
        expect(page).to have_content(@invoice_2.created_at.strftime("%A, %B %d, %Y"))
        expect(page).to have_content(@customer_1.first_name)
        expect(page).to have_content(@customer_1.last_name)
      end
    end
  end


  describe 'User Story 34' do
    it 'I see the information for all relevant items' do
      visit admin_invoice_path(@invoice_1)
     
      expect(page).to have_content(@item_1.name)
      expect(page).to have_content(@invoice_item_1.quantity)
      expect(page).to have_content(@invoice_item_1.price_usd)
      expect(page).to have_content(@invoice_item_1.status)
    end
  end

  describe 'User Story 35' do
    it 'I see the total revenue that will be generated from this invoice' do
      visit admin_invoice_path(@invoice_1)

      within("#invoice_details") do
        expect(page).to have_content(@invoice_1.total_revenue)
      end

      visit admin_invoice_path(@invoice_2)

      within("#invoice_details") do
        expect(page).to have_content(@invoice_2.total_revenue)
      end
    end
  end

  describe 'User Story 36' do
    it 'I see the invoice status is a select field' do
      visit admin_invoice_path(@invoice_1)

      within "#invoice_details" do
        expect(page).to have_select('invoice_status', selected: 'in progress')
      end
    end

    it 'I can update the invoice status' do
      visit admin_invoice_path(@invoice_1)

        within "#invoice-status" do
          select 'completed', from: 'invoice_status'
          click_button 'Update Status'
        end

      @invoice_1.reload
      expect(@invoice_1.status).to eq('completed')
      expect(current_path).to eq(admin_invoice_path(@invoice_1))
    end
  end
end
