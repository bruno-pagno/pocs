import { Test, TestingModule } from '@nestjs/testing';
import { CustomerController } from './customer.controller';
import { CustomerService } from './customer.service';
import { CreateCustomerDto } from './dto/createCustomerDto';
import { v4 as uuidv4 } from 'uuid';
import { Customer } from './domain/customer';
import { UpdateCustomerDto } from './dto/updateCustomerDto';

describe('CustomerController', () => {
  let customerController: CustomerController;
  let customerService: CustomerService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [CustomerController],
      providers: [CustomerService],
    }).compile();

    customerController = module.get<CustomerController>(CustomerController);
    customerService = module.get<CustomerService>(CustomerService);
  });

  describe('createCustomer', () => {
    it('should create a new customer', async () => {
      const createCustomerDto: CreateCustomerDto = {
        name: 'John Doe',
        document: 1234,
      };

      const createdCustomer: Customer = {
        id: uuidv4(),
        name: 'John Doe',
        document: 1234,
      };

      jest
        .spyOn(customerService, 'createCustomer')
        .mockResolvedValue(createdCustomer);

      const result = await customerController.createCustomer(createCustomerDto);

      expect(result).toEqual(createdCustomer);
    });
  });

  describe('getCustomerById', () => {
    it('should retrieve a customer by ID', async () => {
      const id = uuidv4();
      const retrievedCustomer: Customer = {
        id,
        name: 'John Doe',
        document: 1234,
      };

      jest
        .spyOn(customerService, 'getCustomerById')
        .mockResolvedValue(retrievedCustomer);

      const result = await customerController.getCustomerById(id);

      expect(result).toEqual(retrievedCustomer);
    });
  });

  describe('updateCustomerById', () => {
    it('should update a customer by ID', async () => {
      const id = uuidv4();
      const updateCustomerDto: UpdateCustomerDto = {
        id,
        name: 'John Doe',
        document: 1234,
      };

      const updatedCustomer: Customer = {
        id,
        name: 'John Doe',
        document: 1234,
      };

      jest
        .spyOn(customerService, 'updateCustomerById')
        .mockResolvedValue(updatedCustomer);

      const result = await customerController.updateCustomerById(
        id,
        updateCustomerDto,
      );

      expect(result).toEqual(updatedCustomer);
    });
  });
});
