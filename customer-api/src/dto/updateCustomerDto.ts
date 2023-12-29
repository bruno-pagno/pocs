import { IsString, IsNumber, IsOptional } from 'class-validator';

export class UpdateCustomerDto {
  @IsString()
  @IsOptional()
  id: string;

  @IsString()
  @IsOptional()
  name: string;

  @IsNumber()
  @IsOptional()
  document: number;
}
